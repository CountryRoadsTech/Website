# frozen_string_literal: true

# Tracks emails sent to users and if and when they clicked a link.
class CreateSentEmails < ActiveRecord::Migration[6.1]
  def change
    create_table :sent_emails, id: :uuid do |t|
      t.references :user, polymorphic: true, type: :uuid
      t.text :to_ciphertext
      t.string :mailer
      t.text :subject_ciphertext

      t.string :token
      t.timestamp :opened_at
      t.timestamp :clicked_at

      t.timestamp :sent_at
    end

    add_index :sent_emails, :token
  end
end
