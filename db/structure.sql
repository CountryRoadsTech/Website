SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: logidze_compact_history(jsonb, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.logidze_compact_history(log_data jsonb, cutoff integer DEFAULT 1) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
  DECLARE
    merged jsonb;
  BEGIN
    LOOP
      merged := jsonb_build_object(
        'ts',
        log_data#>'{h,1,ts}',
        'v',
        log_data#>'{h,1,v}',
        'c',
        (log_data#>'{h,0,c}') || (log_data#>'{h,1,c}')
      );

      IF (log_data#>'{h,1}' ? 'm') THEN
        merged := jsonb_set(merged, ARRAY['m'], log_data#>'{h,1,m}');
      END IF;

      log_data := jsonb_set(
        log_data,
        '{h}',
        jsonb_set(
          log_data->'h',
          '{1}',
          merged
        ) - 0
      );

      cutoff := cutoff - 1;

      EXIT WHEN cutoff <= 0;
    END LOOP;

    return log_data;
  END;
$$;


--
-- Name: logidze_filter_keys(jsonb, text[], boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.logidze_filter_keys(obj jsonb, keys text[], include_columns boolean DEFAULT false) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
  DECLARE
    res jsonb;
    key text;
  BEGIN
    res := '{}';

    IF include_columns THEN
      FOREACH key IN ARRAY keys
      LOOP
        IF obj ? key THEN
          res = jsonb_insert(res, ARRAY[key], obj->key);
        END IF;
      END LOOP;
    ELSE
      res = obj;
      FOREACH key IN ARRAY keys
      LOOP
        res = res - key;
      END LOOP;
    END IF;

    RETURN res;
  END;
$$;


--
-- Name: logidze_logger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.logidze_logger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    changes jsonb;
    version jsonb;
    snapshot jsonb;
    new_v integer;
    size integer;
    history_limit integer;
    debounce_time integer;
    current_version integer;
    merged jsonb;
    iterator integer;
    item record;
    columns text[];
    include_columns boolean;
    ts timestamp with time zone;
    ts_column text;
  BEGIN
    ts_column := NULLIF(TG_ARGV[1], 'null');
    columns := NULLIF(TG_ARGV[2], 'null');
    include_columns := NULLIF(TG_ARGV[3], 'null');

    IF TG_OP = 'INSERT' THEN
      -- always exclude log_data column
      changes := to_jsonb(NEW.*) - 'log_data';

      IF columns IS NOT NULL THEN
        snapshot = logidze_snapshot(changes, ts_column, columns, include_columns);
      ELSE
        snapshot = logidze_snapshot(changes, ts_column);
      END IF;

      IF snapshot#>>'{h, -1, c}' != '{}' THEN
        NEW.log_data := snapshot;
      END IF;

    ELSIF TG_OP = 'UPDATE' THEN

      IF OLD.log_data is NULL OR OLD.log_data = '{}'::jsonb THEN
        -- always exclude log_data column
        changes := to_jsonb(NEW.*) - 'log_data';

        IF columns IS NOT NULL THEN
          snapshot = logidze_snapshot(changes, ts_column, columns, include_columns);
        ELSE
          snapshot = logidze_snapshot(changes, ts_column);
        END IF;

        IF snapshot#>>'{h, -1, c}' != '{}' THEN
          NEW.log_data := snapshot;
        END IF;
        RETURN NEW;
      END IF;

      history_limit := NULLIF(TG_ARGV[0], 'null');
      debounce_time := NULLIF(TG_ARGV[4], 'null');

      current_version := (NEW.log_data->>'v')::int;

      IF ts_column IS NULL THEN
        ts := statement_timestamp();
      ELSE
        ts := (to_jsonb(NEW.*)->>ts_column)::timestamp with time zone;
        IF ts IS NULL OR ts = (to_jsonb(OLD.*)->>ts_column)::timestamp with time zone THEN
          ts := statement_timestamp();
        END IF;
      END IF;

      IF NEW = OLD THEN
        RETURN NEW;
      END IF;

      IF current_version < (NEW.log_data#>>'{h,-1,v}')::int THEN
        iterator := 0;
        FOR item in SELECT * FROM jsonb_array_elements(NEW.log_data->'h')
        LOOP
          IF (item.value->>'v')::int > current_version THEN
            NEW.log_data := jsonb_set(
              NEW.log_data,
              '{h}',
              (NEW.log_data->'h') - iterator
            );
          END IF;
          iterator := iterator + 1;
        END LOOP;
      END IF;

      changes := '{}';

      IF (coalesce(current_setting('logidze.full_snapshot', true), '') = 'on') THEN
        changes = hstore_to_jsonb_loose(hstore(NEW.*));
      ELSE
        changes = hstore_to_jsonb_loose(
          hstore(NEW.*) - hstore(OLD.*)
        );
      END IF;

      changes = changes - 'log_data';

      IF columns IS NOT NULL THEN
        changes = logidze_filter_keys(changes, columns, include_columns);
      END IF;

      IF changes = '{}' THEN
        RETURN NEW;
      END IF;

      new_v := (NEW.log_data#>>'{h,-1,v}')::int + 1;

      size := jsonb_array_length(NEW.log_data->'h');
      version := logidze_version(new_v, changes, ts);

      IF (
        debounce_time IS NOT NULL AND
        (version->>'ts')::bigint - (NEW.log_data#>'{h,-1,ts}')::text::bigint <= debounce_time
      ) THEN
        -- merge new version with the previous one
        new_v := (NEW.log_data#>>'{h,-1,v}')::int;
        version := logidze_version(new_v, (NEW.log_data#>'{h,-1,c}')::jsonb || changes, ts);
        -- remove the previous version from log
        NEW.log_data := jsonb_set(
          NEW.log_data,
          '{h}',
          (NEW.log_data->'h') - (size - 1)
        );
      END IF;

      NEW.log_data := jsonb_set(
        NEW.log_data,
        ARRAY['h', size::text],
        version,
        true
      );

      NEW.log_data := jsonb_set(
        NEW.log_data,
        '{v}',
        to_jsonb(new_v)
      );

      IF history_limit IS NOT NULL AND history_limit <= size THEN
        NEW.log_data := logidze_compact_history(NEW.log_data, size - history_limit + 1);
      END IF;
    END IF;

    return NEW;
  END;
$$;


--
-- Name: logidze_snapshot(jsonb, text, text[], boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.logidze_snapshot(item jsonb, ts_column text DEFAULT NULL::text, columns text[] DEFAULT NULL::text[], include_columns boolean DEFAULT false) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
  DECLARE
    ts timestamp with time zone;
  BEGIN
    IF ts_column IS NULL THEN
      ts := statement_timestamp();
    ELSE
      ts := coalesce((item->>ts_column)::timestamp with time zone, statement_timestamp());
    END IF;

    IF columns IS NOT NULL THEN
      item := logidze_filter_keys(item, columns, include_columns);
    END IF;

    return json_build_object(
      'v', 1,
      'h', jsonb_build_array(
              logidze_version(1, item, ts)
            )
      );
  END;
$$;


--
-- Name: logidze_version(bigint, jsonb, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.logidze_version(v bigint, data jsonb, ts timestamp with time zone) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
  DECLARE
    buf jsonb;
  BEGIN
    buf := jsonb_build_object(
              'ts',
              (extract(epoch from ts) * 1000)::bigint,
              'v',
              v,
              'c',
              data
              );
    IF coalesce(current_setting('logidze.meta', true), '') <> '' THEN
      buf := jsonb_insert(buf, '{m}', current_setting('logidze.meta')::jsonb);
    END IF;
    RETURN buf;
  END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: action_text_rich_texts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.action_text_rich_texts (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    body text,
    record_type character varying NOT NULL,
    record_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id uuid NOT NULL,
    blob_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    blob_id uuid NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: calendar_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.calendar_events (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    calendar_id uuid NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    duration daterange NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: calendars; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.calendars (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    name text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    visit_id uuid,
    user_id uuid,
    name character varying,
    properties jsonb,
    "time" timestamp without time zone
);


--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.friendly_id_slugs (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    slug character varying NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(50),
    scope character varying,
    created_at timestamp without time zone
);


--
-- Name: links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.links (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    url text NOT NULL,
    slug text NOT NULL,
    number_of_times_used integer DEFAULT 0,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: login_activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.login_activities (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    scope character varying,
    strategy character varying,
    identity character varying,
    success boolean,
    failure_reason character varying,
    user_type character varying,
    user_id uuid,
    context character varying,
    ip_ciphertext text,
    ip_bidx text,
    user_agent_ciphertext text,
    referrer text,
    city_ciphertext text,
    region_ciphertext text,
    country_ciphertext text,
    latitude_ciphertext text,
    longitude_ciphertext text,
    created_at timestamp without time zone
);


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pages (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    title text NOT NULL,
    slug text NOT NULL,
    subtitle text DEFAULT ''::text,
    published_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sent_emails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sent_emails (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    user_type character varying,
    user_id uuid,
    to_ciphertext text,
    mailer character varying,
    subject_ciphertext text,
    token character varying,
    opened_at timestamp without time zone,
    clicked_at timestamp without time zone,
    sent_at timestamp without time zone
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    email_ciphertext text,
    email_bidx character varying,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip_ciphertext text,
    last_sign_in_ip_ciphertext text,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email_ciphertext text,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    admin boolean DEFAULT false,
    name text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: visits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.visits (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    visit_token character varying,
    visitor_token character varying,
    user_id uuid,
    ip_ciphertext text,
    user_agent_ciphertext text,
    referrer text,
    referring_domain character varying,
    landing_page text,
    browser character varying,
    os character varying,
    device_type character varying,
    country_ciphertext text,
    region_ciphertext text,
    city_ciphertext text,
    latitude_ciphertext text,
    longitude_ciphertext text,
    utm_source character varying,
    utm_medium character varying,
    utm_term character varying,
    utm_content character varying,
    utm_campaign character varying,
    started_at timestamp without time zone
);


--
-- Name: action_text_rich_texts action_text_rich_texts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.action_text_rich_texts
    ADD CONSTRAINT action_text_rich_texts_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: calendar_events calendar_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendar_events
    ADD CONSTRAINT calendar_events_pkey PRIMARY KEY (id);


--
-- Name: calendars calendars_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendars
    ADD CONSTRAINT calendars_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: links links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- Name: login_activities login_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.login_activities
    ADD CONSTRAINT login_activities_pkey PRIMARY KEY (id);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sent_emails sent_emails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sent_emails
    ADD CONSTRAINT sent_emails_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: visits visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.visits
    ADD CONSTRAINT visits_pkey PRIMARY KEY (id);


--
-- Name: index_action_text_rich_texts_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_action_text_rich_texts_uniqueness ON public.action_text_rich_texts USING btree (record_type, record_id, name);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_calendar_events_on_calendar_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_calendar_events_on_calendar_id ON public.calendar_events USING btree (calendar_id);


--
-- Name: index_calendar_events_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_calendar_events_on_name ON public.calendar_events USING btree (name);


--
-- Name: index_calendar_events_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_calendar_events_on_slug ON public.calendar_events USING btree (slug);


--
-- Name: index_calendar_events_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_calendar_events_on_user_id ON public.calendar_events USING btree (user_id);


--
-- Name: index_calendars_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_calendars_on_name ON public.calendars USING btree (name);


--
-- Name: index_calendars_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_calendars_on_user_id ON public.calendars USING btree (user_id);


--
-- Name: index_events_on_name_and_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_name_and_time ON public.events USING btree (name, "time");


--
-- Name: index_events_on_properties; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_properties ON public.events USING gin (properties jsonb_path_ops);


--
-- Name: index_events_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_user_id ON public.events USING btree (user_id);


--
-- Name: index_events_on_visit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_visit_id ON public.events USING btree (visit_id);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON public.friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope ON public.friendly_id_slugs USING btree (slug, sluggable_type, scope);


--
-- Name: index_friendly_id_slugs_on_sluggable_type_and_sluggable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type_and_sluggable_id ON public.friendly_id_slugs USING btree (sluggable_type, sluggable_id);


--
-- Name: index_links_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_links_on_slug ON public.links USING btree (slug);


--
-- Name: index_links_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_links_on_user_id ON public.links USING btree (user_id);


--
-- Name: index_login_activities_on_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_login_activities_on_identity ON public.login_activities USING btree (identity);


--
-- Name: index_login_activities_on_ip_bidx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_login_activities_on_ip_bidx ON public.login_activities USING btree (ip_bidx);


--
-- Name: index_login_activities_on_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_login_activities_on_user ON public.login_activities USING btree (user_type, user_id);


--
-- Name: index_pages_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pages_on_slug ON public.pages USING btree (slug);


--
-- Name: index_pages_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pages_on_title ON public.pages USING btree (title);


--
-- Name: index_pages_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pages_on_user_id ON public.pages USING btree (user_id);


--
-- Name: index_sent_emails_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sent_emails_on_token ON public.sent_emails USING btree (token);


--
-- Name: index_sent_emails_on_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sent_emails_on_user ON public.sent_emails USING btree (user_type, user_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email_bidx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email_bidx ON public.users USING btree (email_bidx);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON public.users USING btree (unlock_token);


--
-- Name: index_visits_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_visits_on_user_id ON public.visits USING btree (user_id);


--
-- Name: index_visits_on_visit_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_visits_on_visit_token ON public.visits USING btree (visit_token);


--
-- Name: calendar_events logidze_on_calendar_events; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_calendar_events BEFORE INSERT OR UPDATE ON public.calendar_events FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: calendars logidze_on_calendars; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_calendars BEFORE INSERT OR UPDATE ON public.calendars FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: links logidze_on_links; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_links BEFORE INSERT OR UPDATE ON public.links FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: pages logidze_on_pages; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_pages BEFORE INSERT OR UPDATE ON public.pages FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: users logidze_on_users; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_users BEFORE INSERT OR UPDATE ON public.users FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at', '{email,unconfirmed_at,last_sign_in_ip,current_sign_in_ip}');


--
-- Name: calendar_events fk_rails_0011c39cc3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendar_events
    ADD CONSTRAINT fk_rails_0011c39cc3 FOREIGN KEY (calendar_id) REFERENCES public.calendars(id);


--
-- Name: links fk_rails_005e9b2a6a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT fk_rails_005e9b2a6a FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: pages fk_rails_84a58494eb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT fk_rails_84a58494eb FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: calendar_events fk_rails_930e3c0bf4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendar_events
    ADD CONSTRAINT fk_rails_930e3c0bf4 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: calendars fk_rails_d574754a30; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendars
    ADD CONSTRAINT fk_rails_d574754a30 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20210304005448'),
('20210304221054'),
('20210304221418'),
('20210304222043'),
('20210304223356'),
('20210304230527'),
('20210305001447'),
('20210305003937'),
('20210305005231'),
('20210305170911'),
('20210305170912'),
('20210305181531'),
('20210305185843'),
('20210306221745'),
('20210308205515'),
('20210308205631'),
('20210308205638'),
('20210308205643'),
('20210308205648');


