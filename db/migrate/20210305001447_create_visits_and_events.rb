# frozen_string_literal: true

# Tracks user visits and events across the site.
class CreateVisitsAndEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :visits do |t|
      t.string :visit_token
      t.string :visitor_token

      t.references :user

      t.string :ip
      t.text :user_agent
      t.text :referrer
      t.string :referring_domain
      t.text :landing_page
      t.string :browser
      t.string :os
      t.string :device_type

      # Location
      t.string :country
      t.string :region
      t.string :city
      t.float :latitude
      t.float :longitude

      # UTM Parameters
      t.string :utm_source
      t.string :utm_medium
      t.string :utm_term
      t.string :utm_content
      t.string :utm_campaign

      t.datetime :started_at
    end

    add_index :visits, :visit_token, unique: true

    create_table :events do |t|
      t.references :visit
      t.references :user

      t.string :name
      t.jsonb :properties
      t.datetime :time
    end

    add_index :events, [:name, :time]
    add_index :events, :properties, using: :gin, opclass: :jsonb_path_ops
  end
end
