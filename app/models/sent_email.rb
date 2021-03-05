# frozen_string_literal: true

# == Schema Information
#
# Table name: sent_emails
#
#  id         :bigint           not null, primary key
#  clicked_at :datetime
#  mailer     :string
#  opened_at  :datetime
#  sent_at    :datetime
#  subject    :text
#  to         :text
#  token      :string
#  user_type  :string
#  user_id    :bigint
#
# Indexes
#
#  index_sent_emails_on_token  (token)
#  index_sent_emails_on_user   (user_type,user_id)
#
class SentEmail < ApplicationRecord
  self.table_name = 'sent_emails'

  belongs_to :user, polymorphic: true, optional: true, inverse_of: :sent_emails
end
