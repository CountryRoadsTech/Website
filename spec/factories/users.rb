# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                            :uuid             not null, primary key
#  admin                         :boolean          default(FALSE)
#  confirmation_sent_at          :datetime
#  confirmation_token            :string
#  confirmed_at                  :datetime
#  current_sign_in_at            :datetime
#  current_sign_in_ip_ciphertext :text
#  email_bidx                    :string
#  email_ciphertext              :text
#  encrypted_password            :string           default(""), not null
#  failed_attempts               :integer          default(0), not null
#  last_sign_in_at               :datetime
#  last_sign_in_ip_ciphertext    :text
#  locked_at                     :datetime
#  name                          :text             not null
#  remember_created_at           :datetime
#  reset_password_sent_at        :datetime
#  reset_password_token          :string
#  sign_in_count                 :integer          default(0), not null
#  unconfirmed_email_ciphertext  :text
#  unlock_token                  :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email_bidx            (email_bidx) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
FactoryBot.define do
  factory :user do
  end
end
