# frozen_string_literal: true

# Tracks user visits and events across the site.
class CreateVisitsAndEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :visits, id: :uuid do |t|
      t.string :visit_token
      t.string :visitor_token

      t.references :user, type: :uuid

      t.text :ip_ciphertext
      t.text :user_agent_ciphertext
      t.text :referrer
      t.string :referring_domain
      t.text :landing_page
      t.string :browser
      t.string :os
      t.string :device_type

      # Location
      t.text :country_ciphertext
      t.text :region_ciphertext
      t.text :city_ciphertext
      t.text :latitude_ciphertext
      t.text :longitude_ciphertext

      # UTM Parameters
      t.string :utm_source
      t.string :utm_medium
      t.string :utm_term
      t.string :utm_content
      t.string :utm_campaign

      t.datetime :started_at
    end

    add_index :visits, :visit_token, unique: true

    create_table :events, id: :uuid do |t|
      t.references :visit, type: :uuid
      t.references :user, type: :uuid

      t.string :name
      t.jsonb :properties
      t.datetime :time
    end

    add_index :events, [:name, :time]
    add_index :events, :properties, using: :gin, opclass: :jsonb_path_ops
  end
end
