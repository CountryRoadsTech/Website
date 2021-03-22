# frozen_string_literal: true

# == Schema Information
#
# Table name: links
#
#  id                   :uuid             not null, primary key
#  number_of_times_used :integer          default(0)
#  slug                 :text             not null
#  url                  :text             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :uuid             not null
#
# Indexes
#
#  index_links_on_slug     (slug) UNIQUE
#  index_links_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_005e9b2a6a  (user_id => users.id)
#
FactoryBot.define do
  factory :link do
    user { nil }
    url { 'MyText' }
    slug { 'MyText' }
    number_of_times_used { 1 }
  end
end
