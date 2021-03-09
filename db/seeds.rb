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
NUMBER_OF_SEED_CALENDARS = 5
MAX_NUMBER_OF_RANDOM_SEED_EVENTS_PER_CALENDAR = 50

VALID_PASSWORD = "Passwordpassword1?" # Passwords must be between 12 and 128 characters, and include:
                                      # 1 upper case, 1 lower case, 1 number, and 1 special character

NUMBER_OF_SEED_USERS.times.each do
  user = User.new(email: Faker::Internet.unique.email, name: Faker::Name.name, password: VALID_PASSWORD, password_confirmation: VALID_PASSWORD)
  user.skip_confirmation!
  user.save!
end

# Create an admin seed user.
user = User.new(email: 'email@website.com', name: 'Addison Martin', password: 'Passwordpassword1*', password_confirmation: 'Passwordpassword1*')
user.skip_confirmation!
user.admin = true
user.save!

NUMBER_OF_SEED_PAGES.times.each do
  user = User.order(Arel.sql('RANDOM()')).first
  article = Page.new(user: user, title: Faker::Lorem.unique.sentence, subtitle: Faker::Lorem.sentence,
                     content: Faker::Lorem.paragraph)
  article.save!
end

NUMBER_OF_SEED_CALENDARS.times.each do
  user = User.order(Arel.sql('RANDOM()')).first
  calendar = Calendar.new(user: user, name: Faker::Lorem.sentence)
  calendar.save!

  (2..(rand(MAX_NUMBER_OF_RANDOM_SEED_EVENTS_PER_CALENDAR) + 2)).each do
    calendar_event = CalendarEvent.new(user: user, calendar: calendar, name: Faker::Lorem.sentence,
                                       description: Faker::Lorem.paragraph,
                                       duration: (Faker::Time.backward(days: 5)..Faker::Time.forward(days: 5)))
    calendar_event.save!
  end

  calendar.save!
end
