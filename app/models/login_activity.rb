# frozen_string_literal: true

# == Schema Information
#
# Table name: login_activities
#
#  id                   :uuid             not null, primary key
#  city_ciphertext      :text
#  context              :string
#  country_ciphertext   :text
#  failure_reason       :string
#  identity_bidx        :string
#  identity_ciphertext  :text
#  ip_bidx              :text
#  ip_ciphertext        :text
#  latitude_ciphertext  :text
#  longitude_ciphertext :text
#  referrer             :text
#  region_ciphertext    :text
#  scope                :string
#  strategy             :string
#  success              :boolean
#  user_agent           :text
#  user_type            :string
#  created_at           :datetime
#  user_id              :uuid
#
# Indexes
#
#  index_login_activities_on_identity_bidx  (identity_bidx)
#  index_login_activities_on_ip_bidx        (ip_bidx)
#  index_login_activities_on_user           (user_type,user_id)
#
class LoginActivity < ApplicationRecord
  # Sets the default way these records are sorted. Because UUIDs are used, the default sort order does not work.
  default_scope { order(created_at: :desc) }

  belongs_to :user, polymorphic: true, optional: true, inverse_of: :login_activities

  # Encrypt some of the more sensitive database field.
  encrypts :ip, :city, :region, :country, :identity
  encrypts :latitude, :longitude, type: :float
  blind_index :ip, slow: true
  blind_index :identity, slow: true

  # Raise an error if a N+1 database query occurs.
  self.strict_loading_by_default = true

  # Adds the .to_xlsx, .to_ods, .to_csv
  include SpreadsheetArchitect

  # Column format is: [Header, Cell Data / Method (if symbol) to Call on each Instance, (optional) Cell Type]
  def spreadsheet_columns
    [
      ['ID', :id],
      ['Created At', :created_at],
      ['User', :user.email],
      ['IP', :ip],
      ['Latitude', :latitude],
      ['Longitude', :longitude],
      ['City', :city],
      ['Region', :region],
      ['Country', :country],
      ['Context', :context],
      ['Failure Reason', :failure_reason],
      ['Identity', :identity],
      ['Referrer', :referrer],
      ['Scope', :scope],
      ['Strategy', :strategy],
      ['Success?', :success],
      ['User Agent', :user_agent],
      ['User Type', :user_type]
    ]
  end
end
