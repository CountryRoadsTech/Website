# frozen_string_literal: true

FactoryBot.define do
  factory :page do
    user { nil }
    title { 'MyText' }
    subtitle { 'MyText' }
    slug { 'MyText' }
    published_at { '2021-03-04 17:33:56' }
  end
end
