# frozen_string_literal: true

# == Schema Information
#
# Table name: visits
#
#  id               :bigint           not null, primary key
#  browser          :string
#  city             :string
#  country          :string
#  device_type      :string
#  ip               :string
#  landing_page     :text
#  latitude         :float
#  longitude        :float
#  os               :string
#  referrer         :text
#  referring_domain :string
#  region           :string
#  started_at       :datetime
#  user_agent       :text
#  utm_campaign     :string
#  utm_content      :string
#  utm_medium       :string
#  utm_source       :string
#  utm_term         :string
#  visit_token      :string
#  visitor_token    :string
#  user_id          :bigint
#
# Indexes
#
#  index_visits_on_user_id      (user_id)
#  index_visits_on_visit_token  (visit_token) UNIQUE
#
class Visit < ApplicationRecord
  self.table_name = 'visits'

  has_many :events, class_name: 'Event', inverse_of: :visit, dependent: :destroy
  belongs_to :user, optional: true, inverse_of: :visits

  # Raise an error if a N+1 database query occurs.
  self.strict_loading_by_default = true
end
