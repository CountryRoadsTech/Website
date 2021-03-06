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
FactoryBot.define do
  factory :calendar_event do
    user { nil }
    name { 'MyText' }
    duration { '' }
  end
end
