# frozen_string_literal: true

# == Schema Information
#
# Table name: calendars
#
#  id         :uuid             not null, primary key
#  name       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_calendars_on_name     (name)
#  index_calendars_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_d574754a30  (user_id => users.id)
#
class Calendar < ApplicationRecord
  # Sets the default way these records are sorted. Because UUIDs are used, the default sort order does not work.
  default_scope { order(created_at: :desc) }

  belongs_to :user, inverse_of: :calendars
  has_many :calendar_events, inverse_of: :calendar, dependent: :destroy

  validates :name, presence: true

  has_paper_trail # Track and store changes to this model

  # Use Hotwire to send live updates (via Action Cable) to the user's browser.
  #after_create_commit { broadcast_prepend_to 'calendars' }
  #after_update_commit { broadcast_replace_to 'calendars' }
  #after_destroy_commit { broadcast_remove_to 'calendars' }

  include PgSearch::Model
  multisearchable against: :name,
                  update_if: :name_changed?,
                  additional_attributes: ->(model) { { user_id: model.user_id } }

  # Adds the .to_xlsx, .to_ods, .to_csv methods
  include SpreadsheetArchitect

  # Column format is: [Header, Cell Data / Method (if symbol) to Call on each Instance, (optional) Cell Type]
  def spreadsheet_columns
    [
      ['ID', :id],
      ['Created At', :created_at],
      ['Name', :name],
      ['Number of Events', :calendar_events.count],
      ['User', :user]
    ]
  end
end
