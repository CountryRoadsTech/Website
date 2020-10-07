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
#  index_sent_emails_on_token                  (token)
#  index_sent_emails_on_user_type_and_user_id  (user_type,user_id)
#
class SentEmail < ApplicationRecord
  belongs_to :user, optional: true
end
