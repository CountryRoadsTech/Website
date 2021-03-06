# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  log_data               :jsonb
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
class User < ApplicationRecord
  # Include devise authentication modules:
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_logidze # Track and store changes to this model.

  has_many :pages, inverse_of: :user, dependent: :destroy
  has_many :calendars, inverse_of: :user, dependent: :destroy
  has_many :calendar_events, inverse_of: :user, dependent: :destroy

  has_many :visits, class_name: 'Visit', inverse_of: :user, dependent: :destroy
  has_many :events, class_name: 'Event', inverse_of: :user, dependent: :destroy
  has_many :sent_emails, class_name: 'SentEmail', as: :user, inverse_of: :user, dependent: :destroy
  has_many :login_activities, class_name: 'LoginActivity', as: :user, inverse_of: :user, dependent: :destroy

  # Raise an error if a N+1 database query occurs.
  self.strict_loading_by_default = true

  # Adds the .to_xlsx, .to_ods, .to_csv
  include SpreadsheetArchitect

  # Column format is: [Header, Cell Data / Method (if symbol) to Call on each Instance, (optional) Cell Type]
  def spreadsheet_columns
    [
      ['ID', :id],
      ['Created At', :created_at],
      ['Admin?', :admin?],
      ['Email', :email],
      ['Email Confirmed?', :confirmed_at.nil?],
      ['Number of Successful Sign Ins', :sign_in_count],
      ['Number of Calendars', :calendars.count],
      ['Number of Calendar Events', :calendar_events.count],
      ['Number of Visits', :visits.count],
      ['Number of Events', :events.count],
      ['Number of Emails Sent To User', :sent_emails.count]
    ]
  end
end
