source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'rails', '~> 6.0.3', '>= 6.0.3.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production and provide caching.
gem 'redis', '~> 4.2'
# Hiredis is a high speed connection library for Redis written in C.
gem 'hiredis', '~> 0.6'

# Use Active Storage variant to resize and crop uploaded images.
gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Sidekiq is used as an Active Job backend, to perform async tasks.
gem 'sidekiq', '~> 6.1'

# Dotenv is used to load in variables from .env files.
gem 'dotenv-rails', '~> 2.7'

# Sentry Raven reports exceptions to sentry.io.
gem 'sentry-raven', '~> 3.1'

# Rack Attack is used to throttle and block spammy and potentially abusive clients.
gem 'rack-attack', '~> 6.3'

# Devise is used to add user authentication.
gem 'devise', '~> 4.7'

group :development, :test do
  # Pry is a runtime development console and IRB alternative.
  gem 'pry', '~> 0.13'
  # Pry Rails replaces Rail's console with a Pry console, and adds several Rails specific features to Pry.
  gem 'pry-rails', '~> 0.3'
  # Pry Byebug adds debugging features to Pry.
  gem 'pry-byebug', '~> 3.9'

  # RSpec Rails replace Rail's default test framework with RSpec.
  gem 'rspec-rails', '~> 4.0'
  # Factory Bot Rails is used to replace Rail's default test fixtures with test factories.
  gem 'factory_bot_rails', '~> 6.1'
  # Faker is used to generate random, fake data.
  gem 'faker', '~> 2.14'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Better Errors replaces Rail's default error page with an improved, interactive one.
  gem 'better_errors', '~> 2.8'
  # Binding of Caller is used by Better Errors to enable some of its more advanced features.
  gem 'binding_of_caller', '~> 0.8'
  # Better Errors Pry adds Pry support to Better Errors error pages.
  gem 'better_errors-pry', '~> 1.0'
end

group :test do
  # Capybara is used to simulate how a real user interacts with webpages and can run Javascript.
  gem 'capybara', '~> 3.33'
  # Selenium Webdriver is used by Capybara to run Javascript.
  gem 'selenium-webdriver', '~> 3.142'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
