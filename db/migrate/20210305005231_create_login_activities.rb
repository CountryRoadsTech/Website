# frozen_string_literal: true

# Tracks successful and unsuccessful login attempts.
class CreateLoginActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :login_activities, id: :uuid do |t|
      t.string :scope
      t.string :strategy
      t.text :identity_ciphertext
      t.string :identity_bidx
      t.boolean :success
      t.string :failure_reason
      t.references :user, polymorphic: true, type: :uuid
      t.string :context
      t.text :ip_ciphertext
      t.text :ip_bidx
      t.text :user_agent
      t.text :referrer
      t.text :city_ciphertext
      t.text :region_ciphertext
      t.text :country_ciphertext
      t.text :latitude_ciphertext
      t.text :longitude_ciphertext
      t.datetime :created_at
    end

    add_index :login_activities, :ip_bidx
    add_index :login_activities, :identity_bidx
  end
end
