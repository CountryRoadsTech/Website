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
FactoryBot.define do
  factory :calendar do
    user { nil }
    calendar_events { '' }
    name { 'MyText' }
  end
end
