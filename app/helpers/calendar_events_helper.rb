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
module CalendarEventsHelper
end
