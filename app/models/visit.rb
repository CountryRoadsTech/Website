# frozen_string_literal: true

# == Schema Information
#
# Table name: visits
#
#  id                    :uuid             not null, primary key
#  browser               :string
#  city_ciphertext       :text
#  country_ciphertext    :text
#  device_type           :string
#  ip_ciphertext         :text
#  landing_page          :text
#  latitude_ciphertext   :text
#  longitude_ciphertext  :text
#  os                    :string
#  referrer              :text
#  referring_domain      :string
#  region_ciphertext     :text
#  started_at            :datetime
#  user_agent_ciphertext :text
#  utm_campaign          :string
#  utm_content           :string
#  utm_medium            :string
#  utm_source            :string
#  utm_term              :string
#  visit_token           :string
#  visitor_token         :string
#  user_id               :uuid
#
# Indexes
#
#  index_visits_on_user_id      (user_id)
#  index_visits_on_visit_token  (visit_token) UNIQUE
#
class Visit < ApplicationRecord
  self.table_name = 'visits'

  # Sets the default way these records are sorted. Because UUIDs are used, the default sort order does not work.
  default_scope { order(started_at: :desc) }

  has_many :events, inverse_of: :visit, dependent: :destroy
  belongs_to :user, optional: true, inverse_of: :visits

  # Encrypt some of the more sensitive database field.
  encrypts :city, :context, :country, :ip, :region, :user_agent
  encrypts :latitude, :longitude, type: :float

  # Raise an error if a N+1 database query occurs.
  self.strict_loading_by_default = true

  # Adds the .to_xlsx, .to_ods, .to_csv
  include SpreadsheetArchitect

  # Adds the .to_xlsx, .to_ods, .to_csv
  include SpreadsheetArchitect

  # Column format is: [Header, Cell Data / Method (if symbol) to Call on each Instance, (optional) Cell Type]
  def spreadsheet_columns
    [
      ['ID', :id],
      ['Started At', :started_at],
      ['User', :user.email],
      ['IP', :ip],
      ['Latitude', :latitude],
      ['Longitude', :longitude],
      ['City', :city],
      ['Region', :region],
      ['Country', :country],
      ['Browser', :browser],
      ['OS', :os],
      ['Landing Page', :landing_page],
      ['Referrer', :referrer],
      ['Referring Domain', :referring_domain],
      ['User Agent', :user_agent],
      ['Success?', :success],
      ['User Agent', :user_agent],
      ['UTM Campaign', :utm_campaign],
      ['UTM Content', :utm_content],
      ['UTM Medium', :utm_medium],
      ['UTM Source', :utm_source],
      ['UTM Term', :utm_term]
    ]
  end
end
