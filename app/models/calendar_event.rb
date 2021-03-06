# frozen_string_literal: true

# == Schema Information
#
# Table name: calendar_events
#
#  id          :bigint           not null, primary key
#  duration    :daterange        not null
#  log_data    :jsonb
#  name        :text             not null
#  slug        :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  calendar_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_calendar_events_on_calendar_id  (calendar_id)
#  index_calendar_events_on_name         (name)
#  index_calendar_events_on_slug         (slug) UNIQUE
#  index_calendar_events_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_0011c39cc3  (calendar_id => calendars.id)
#  fk_rails_930e3c0bf4  (user_id => users.id)
#
class CalendarEvent < ApplicationRecord
  belongs_to :user, inverse_of: :calendar_events
  belongs_to :calendar, inverse_of: :calendar_events

  has_rich_text :description
  has_many_attached :attachments

  validates :name, :user, :calendar, :duration, presence: true

  has_logidze # Track and store changes to this model.

  extend FriendlyId # View events at URLs based on their name not ID.
  friendly_id :name, use: :slugged

  # Use Hotwire to send live updates (via Action Cable) to the user's browser.
  after_create_commit { broadcast_prepend_to 'events' }
  after_update_commit { broadcast_replace_to 'events' }
  after_destroy_commit { broadcast_remove_to 'events' }

  def start_time
    self.duration.begin
  end

  def end_time
    self.duration.end
  end

  # Adds the .to_xlsx, .to_ods, .to_csv
  include SpreadsheetArchitect

  # Column format is: [Header, Cell Data / Method (if symbol) to Call on each Instance, (optional) Cell Type]
  def spreadsheet_columns
    [
      ['ID', :id],
      ['Name', :name],
      ['Starts At', :starts_at],
      ['Ends At', :ends_at],
      ['Duration', :duration],
      ['Calendar', :calendar.name],
      ['User', :user.email]
    ]
  end
end
