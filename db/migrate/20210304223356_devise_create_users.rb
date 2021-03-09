# frozen_string_literal: true

# The User model that can be signed in/out, may have pages, may be an admin, etc.
class DeviseCreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: :uuid do |t|
      ## Database authenticatable
      t.text :email_ciphertext
      t.string :email_bidx
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.text :current_sign_in_ip_ciphertext
      t.text :last_sign_in_ip_ciphertext

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.text :unconfirmed_email_ciphertext

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false
      t.string   :unlock_token
      t.datetime :locked_at

      t.boolean :admin, default: false

      t.timestamps null: false
    end

    add_index :users, :email_bidx,           unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
  end
end
