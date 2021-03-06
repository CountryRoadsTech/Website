# frozen_string_literal: true

# == Schema Information
#
# Table name: sent_emails
#
#  id                    :uuid             not null, primary key
#  clicked_at_ciphertext :text
#  mailer                :string
#  opened_at_ciphertext  :text
#  sent_at               :datetime
#  subject_ciphertext    :text
#  to_ciphertext         :text
#  token                 :string
#  user_type             :string
#  user_id               :uuid
#
# Indexes
#
#  index_sent_emails_on_token  (token)
#  index_sent_emails_on_user   (user_type,user_id)
#
class SentEmail < ApplicationRecord
  self.table_name = 'sent_emails'

  # Sets the default way these records are sorted. Because UUIDs are used, the default sort order does not work.
  default_scope { order(sent_at: :desc) }

  belongs_to :user, polymorphic: true, optional: true, inverse_of: :sent_emails

  # Encrypt some of the more sensitive database field.
  encrypts :subject, :to
  encrypts :opened_at, :clicked_at, type: :datetime

  # Raise an error if a N+1 database query occurs.
  self.strict_loading_by_default = true

  # Adds the .to_xlsx, .to_ods, .to_csv
  include SpreadsheetArchitect

  # Column format is: [Header, Cell Data / Method (if symbol) to Call on each Instance, (optional) Cell Type]
  def spreadsheet_columns
    [
      ['ID', :id],
      ['To', :to],
      ['Subject', :subject],
      ['Mailer', :mailer],
      ['Sent At', :sent_at],
      ['Clicked At', :clicked_at]
    ]
  end
end
