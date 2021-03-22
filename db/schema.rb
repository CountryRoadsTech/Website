# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_22_174511) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "calendar_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "calendar_id", null: false
    t.text "name", null: false
    t.text "slug", null: false
    t.daterange "duration", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["calendar_id"], name: "index_calendar_events_on_calendar_id"
    t.index ["name"], name: "index_calendar_events_on_name"
    t.index ["slug"], name: "index_calendar_events_on_slug", unique: true
    t.index ["user_id"], name: "index_calendar_events_on_user_id"
  end

  create_table "calendars", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.text "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_calendars_on_name"
    t.index ["user_id"], name: "index_calendars_on_user_id"
  end

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "visit_id"
    t.uuid "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_events_on_name_and_time"
    t.index ["properties"], name: "index_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_events_on_user_id"
    t.index ["visit_id"], name: "index_events_on_visit_id"
  end

  create_table "friendly_id_slugs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "slug", null: false
    t.uuid "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "links", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.text "url", null: false
    t.text "slug", null: false
    t.integer "number_of_times_used", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_links_on_slug", unique: true
    t.index ["user_id"], name: "index_links_on_user_id"
  end

  create_table "login_activities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "scope"
    t.string "strategy"
    t.string "identity"
    t.boolean "success"
    t.string "failure_reason"
    t.string "user_type"
    t.uuid "user_id"
    t.string "context"
    t.text "ip_ciphertext"
    t.text "ip_bidx"
    t.text "user_agent_ciphertext"
    t.text "referrer"
    t.text "city_ciphertext"
    t.text "region_ciphertext"
    t.text "country_ciphertext"
    t.text "latitude_ciphertext"
    t.text "longitude_ciphertext"
    t.datetime "created_at"
    t.index ["identity"], name: "index_login_activities_on_identity"
    t.index ["ip_bidx"], name: "index_login_activities_on_ip_bidx"
    t.index ["user_type", "user_id"], name: "index_login_activities_on_user"
  end

  create_table "pages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.text "title", null: false
    t.text "slug", null: false
    t.text "subtitle", default: ""
    t.datetime "published_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_pages_on_slug", unique: true
    t.index ["title"], name: "index_pages_on_title", unique: true
    t.index ["user_id"], name: "index_pages_on_user_id"
  end

  create_table "sent_emails", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "user_type"
    t.uuid "user_id"
    t.text "to_ciphertext"
    t.string "mailer"
    t.text "subject_ciphertext"
    t.string "token"
    t.datetime "opened_at"
    t.datetime "clicked_at"
    t.datetime "sent_at"
    t.index ["token"], name: "index_sent_emails_on_token"
    t.index ["user_type", "user_id"], name: "index_sent_emails_on_user"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "email_ciphertext"
    t.string "email_bidx"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.text "current_sign_in_ip_ciphertext"
    t.text "last_sign_in_ip_ciphertext"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.text "unconfirmed_email_ciphertext"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.boolean "admin", default: false
    t.text "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email_bidx"], name: "index_users_on_email_bidx", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type"
    t.string "{:null=>false}"
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "visits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.uuid "user_id"
    t.text "ip_ciphertext"
    t.text "user_agent_ciphertext"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.text "country_ciphertext"
    t.text "region_ciphertext"
    t.text "city_ciphertext"
    t.text "latitude_ciphertext"
    t.text "longitude_ciphertext"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_visits_on_user_id"
    t.index ["visit_token"], name: "index_visits_on_visit_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "calendar_events", "calendars"
  add_foreign_key "calendar_events", "users"
  add_foreign_key "calendars", "users"
  add_foreign_key "links", "users"
  add_foreign_key "pages", "users"
end
