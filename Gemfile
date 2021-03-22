# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'rails', '~> 6.1.3'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use Active Storage variant
gem 'image_processing', '~> 1.2'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Devise adds user authentication.
gem 'devise', '~> 4.7'
# Devise Masquerade allows admin users to sign in as other users.
gem 'devise_masquerade', '~> 1.3'
# Pundit adds users authorization.
gem 'pundit', '~> 2.1'

# Sidekiq is used to process async, background jobs.
gem 'sidekiq', '~> 6.1'

# Connection Pool is used by Redis to take advantage of connection pooling.
gem 'connection_pool', '~> 2.2'
# Hiredis is a high speed connection library for Redis.
gem 'hiredis', '~> 0.6'

# Rack Attack throttles and blocks spammy and abusive clients.
gem 'rack-attack', '~> 6.5'

# Ahoy Matey adds local, first-party user analytics.
gem 'ahoy_matey', '~> 3.2'
# Ahoy Email adds local, first-party email analytics.
gem 'ahoy_email', '~> 1.1'
# Authtrail tracks successful and unsuccessful login attempts.
gem 'authtrail', '~> 0.3'
# Paper Trail tracks and stores changes to database models.
gem 'paper_trail', '~> 11.1'

# New Relic is used to provide monitoring of the application in production.
gem 'newrelic_rpm', '~> 6.15'
# Honey Badger is used to report errors in production.
gem 'honeybadger', '~> 4.7'

# Pagy adds pagination to controllers as well as view helpers.
gem 'pagy', '~> 4.1'
# OJ is used by pagy to increase performance of Pagy's Javascript views.
gem 'oj', '~> 3.11'

# Friendly ID allows changing which model's attribute is used in the model's URL.
gem 'friendly_id', '~> 5.4'

# Turbo delivers HTML over the wire to provide live updates to the website without having to refresh the entire page.
gem 'turbo-rails', '~> 0.5'

# Simple Calendar is used to render calendars in views.
gem 'simple_calendar', '~> 2.4'
# Holidays is used to get a list of holidays for a given region.
gem 'holidays', '~> 8.4'

# Spreadsheet Architect is used to export models and their relationships to CSV, XLSX, and ODS.
gem 'spreadsheet_architect', '~> 4.1'
# Active Record Import is used to efficiently import CSV and XLSX files.
gem 'activerecord-import', '~> 1.0'
# Ruby Zip is used to zip and unzip files.
gem 'rubyzip', '~> 2.3'

# Lockbox is used to encrypt data in the database.
gem 'lockbox', '~> 0.6'
# Blind Index is used to search encrypted database fields.
gem 'blind_index', '~> 2.2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # RSpec replaces Rail's default testing framework.
  gem 'rspec-rails', '~> 4.0'
  # Factory Bot replaces Rail's default test fixtures with test factories.
  gem 'factory_bot_rails', '~> 6.1'
  # Faker is used to generated fake, but realistic looking data for testing and development.
  gem 'faker', '~> 2.16'
  # Capybara is used to create integration tests but simulating how the end user interacts with the website.
  gem 'capybara', '~> 3.35'
  # Selenium Webdriver is used by Capybara as its webdriver.
  gem 'selenium-webdriver', '~> 3.142'

  # Rubocop is this project's code style and linter enforcer.
  gem 'rubocop', '~> 1.11'
  # Rubocop Rails adds Rail's specific checks to Rubocop.
  gem 'rubocop-rails', '~> 2.9'
  # Rubocop RSpec adds RSpec specific checks to Rubocop.
  gem 'rubocop-rspec', '~> 2.2'
  # Rubocop Rake adds Rake specific checks to Rubocop.
  gem 'rubocop-rake', '~> 0.5'
  # Rubocop Performance adds performance specific checks to Rubocop.
  gem 'rubocop-performance', '~> 1.10'

  # Brakeman is a static code analyzer that detects security vulnerabilities.
  gem 'brakeman', '~> 5.0'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Annotate automatically adds database schema information to the top of relevant Ruby classes during rake db:migrate.
  gem 'annotate', '~> 3.1'

  # Better Errors replaces Rail's default error pages.
  gem 'better_errors', '~> 2.9'
  # Binding of Caller is used by Better Errors.
  gem 'binding_of_caller', '~> 1.0'

  # Letter Opener is used to open emails sent by the application directly in a new tab of the browser.
  gem 'letter_opener', '~> 1.7'
end
