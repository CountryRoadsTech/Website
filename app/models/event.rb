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

  self.table_name = 'events'

  belongs_to :visit, inverse_of: :events
  belongs_to :user, optional: true, inverse_of: :events

  # Raise an error if a N+1 database query occurs.
  self.strict_loading_by_default = true
end
