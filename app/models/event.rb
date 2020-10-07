# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id         :bigint           not null, primary key
#  name       :string
#  properties :jsonb
#  time       :datetime
#  user_id    :bigint
#  visit_id   :bigint
#
# Indexes
#
#  index_events_on_name_and_time  (name,time)
#  index_events_on_properties     (properties) USING gin
#  index_events_on_user_id        (user_id)
#  index_events_on_visit_id       (visit_id)
#
class Event < ApplicationRecord
  include Ahoy::QueryMethods

  belongs_to :visit
  belongs_to :user, optional: true
end
