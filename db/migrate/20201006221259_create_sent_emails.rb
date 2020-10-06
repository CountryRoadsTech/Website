class CreateSentEmails < ActiveRecord::Migration[6.0]
  def change
    create_table :sent_emails do |t|
      t.references :user, polymorphic: true
      t.text :to
      t.string :mailer
      t.text :subject
      t.timestamp :sent_at

      # Used to track if/when the user opened the email message:
      t.string :token
      t.timestamp :opened_at
      t.timestamp :clicked_at
    end

    add_index :sent_emails, :token
  end
end
