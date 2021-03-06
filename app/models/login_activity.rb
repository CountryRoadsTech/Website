# frozen_string_literal: true

# == Schema Information
#
# Table name: login_activities
#
#  id             :bigint           not null, primary key
#  city           :string
#  context        :string
#  country        :string
#  failure_reason :string
#  identity       :string
#  ip             :string
#  latitude       :float
#  longitude      :float
#  referrer       :text
#  region         :string
#  scope          :string
#  strategy       :string
#  success        :boolean
#  user_agent     :text
#  user_type      :string
#  created_at     :datetime
#  user_id        :bigint
#
# Indexes
#
#  index_login_activities_on_identity  (identity)
#  index_login_activities_on_ip        (ip)
#  index_login_activities_on_user      (user_type,user_id)
#
class LoginActivity < ApplicationRecord
  belongs_to :user, polymorphic: true, optional: true, inverse_of: :login_activities

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
