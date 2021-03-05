# frozen_string_literal: true

# == Schema Information
#
# Table name: calendar_events
#
#  id         :bigint           not null, primary key
#  duration   :daterange
#  name       :text             not null
#  slug       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_calendar_events_on_name     (name)
#  index_calendar_events_on_slug     (slug) UNIQUE
#  index_calendar_events_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_930e3c0bf4  (user_id => users.id)
#
class CalendarEvent < ApplicationRecord
  belongs_to :user, inverse_of: :events

  has_rich_text :description
  has_many_attached :attachments

  validates :name, :user, presence: true

  has_logidze # Track and store changes to this model.

  extend FriendlyId # View events at URLs based on their name not ID.
  friendly_id :name, use: :slugged

  # Use Hotwire to send live updates (via Action Cable) to the user's browser.
  after_create_commit { broadcast_prepend_to 'events' }
  after_update_commit { broadcast_replace_to 'events' }
  after_destroy_commit { broadcast_remove_to 'events' }
end
