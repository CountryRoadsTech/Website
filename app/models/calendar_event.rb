# frozen_string_literal: true

# == Schema Information
#
# Table name: calendar_events
#
#  id          :uuid             not null, primary key
#  duration    :daterange        not null
#  name        :text             not null
#  slug        :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  calendar_id :uuid             not null
#  user_id     :uuid             not null
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
  # Sets the default way these records are sorted. Because UUIDs are used, the default sort order does not work.
  default_scope { order(created_at: :desc) }

  belongs_to :user, inverse_of: :calendar_events
  belongs_to :calendar, inverse_of: :calendar_events

  has_rich_text :description
  has_many_attached :attachments

  validates :name, :user, :calendar, :duration, presence: true

  has_paper_trail # Track and store changes to this model

  extend FriendlyId # View events at URLs based on their name not ID.
  friendly_id :name, use: :history

  # Use Hotwire to send live updates (via Action Cable) to the user's browser.
  after_create_commit { broadcast_prepend_to 'events' }
  after_update_commit { broadcast_replace_to 'events' }
  after_destroy_commit { broadcast_remove_to 'events' }

  def start_time
    duration.begin
  end

  def end_time
    duration.end
  end

  include PgSearch::Model
  multisearchable against: [:name, :description],
                  additional_attributes: ->(model) { { user_id: model.user_id } }

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
