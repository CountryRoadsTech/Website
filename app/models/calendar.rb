# frozen_string_literal: true

# == Schema Information
#
# Table name: calendars
#
#  id         :bigint           not null, primary key
#  log_data   :jsonb
#  name       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
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
  belongs_to :user, inverse_of: :calendars
  has_many :calendar_events, inverse_of: :calendar, dependent: :destroy

  validates :name, presence: true

  has_logidze # Track and store changes to this model

  # Use Hotwire to send live updates (via Action Cable) to the user's browser.
  #after_create_commit { broadcast_prepend_to 'calendars' }
  #after_update_commit { broadcast_replace_to 'calendars' }
  #after_destroy_commit { broadcast_remove_to 'calendars' }

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
