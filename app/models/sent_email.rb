# frozen_string_literal: true

# Tracks emails sent to users and if and when they clicked a link.
class SentEmails < ApplicationRecord
  self.table_name = 'sent_emails'

  belongs_to :user, polymorphic: true, optional: true, inverse_of: :sent_emails
end
