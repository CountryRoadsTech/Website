# frozen_string_literal: true

# == Schema Information
#
# Table name: pages
#
#  id           :uuid             not null, primary key
#  log_data     :jsonb
#  published_at :datetime
#  slug         :text             not null
#  subtitle     :text             default("")
#  title        :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :uuid             not null
#
# Indexes
#
#  index_pages_on_slug     (slug) UNIQUE
#  index_pages_on_title    (title) UNIQUE
#  index_pages_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_84a58494eb  (user_id => users.id)
#
FactoryBot.define do
  factory :page do
    user { nil }
    title { 'MyText' }
    subtitle { 'MyText' }
    slug { 'MyText' }
    published_at { '2021-03-04 17:33:56' }
  end
end
