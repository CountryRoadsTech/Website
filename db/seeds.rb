# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

NUMBER_OF_SEED_USERS = 10
NUMBER_OF_SEED_PAGES = 100
NUMBER_OF_SEED_CALENDAR_EVENTS = 250

NUMBER_OF_SEED_USERS.times.each do
  password = Faker::String.random(length: 12..128)
  user = User.new(email: Faker::Internet.unique.email, password: password, password_confirmation: password)
  user.skip_confirmation!
  user.save!
end

NUMBER_OF_SEED_PAGES.times.each do
  user = User.find((rand(NUMBER_OF_SEED_USERS) + 1))
  article = Page.new(user: user, title: Faker::Lorem.unique.sentence, subtitle: Faker::Lorem.sentence,
                     content: Faker::Lorem.paragraph)
  article.save!
end

NUMBER_OF_SEED_CALENDAR_EVENTS.times.each do
  user = User.find((rand(NUMBER_OF_SEED_USERS) + 1))
  calendar_event = CalendarEvent.new(user: user, name: Faker::Lorem.sentence, description: Faker::Lorem.paragraph)
  calendar_event.save!
end
