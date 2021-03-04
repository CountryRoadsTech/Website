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

# Friendly ID allows changing which model's attribute is used in the model's URL.
gem 'friendly_id', '~> 5.4'

# Devise adds user authentication.
gem 'devise', '~> 4.7'

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
end
