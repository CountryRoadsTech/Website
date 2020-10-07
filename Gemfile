# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

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

# Meta Tags is used to add search engine optimization meta tags.
gem 'meta-tags', '~> 2.13'

# Dotenv is used to load in variables from .env files.
gem 'dotenv-rails', '~> 2.7'

# Slim Rails adds the Slim templating language to the application, which replaces HTML/ERB.
gem 'slim-rails', '~> 3.2'
# Stimulus Reflex builds on top of Stimulus to add reactive components.
gem 'stimulus_reflex', '~> 3.3'
# View Component is used to create view components that are reusable, testable, and encapsulated.
gem 'view_component', '~> 2.19', require: 'view_component/engine'

# Paper Trail is used to track changes to models.
gem 'paper_trail', '~> 11.0'
# Discard is used to soft delete models.
gem 'discard', '~> 1.2'

# Friendly ID is used to replace the URL slug for models with something other than ID.
gem 'friendly_id', '~> 5.4'

# Sentry Raven reports exceptions to sentry.io.
gem 'sentry-raven', '~> 3.1'

# Rack Mini Profiler adds a performance speed page to the top of every page.
# For development it is always visible, for production it is only visible if the user is an admin.
gem 'rack-mini-profiler', '~> 2.1'
# Memory Profiler is used by Rack Min Profiler for memory profiling
gem 'memory_profiler', '~> 0.9'
# Flamegraph is used by Rack Mini Profiler for call-stack profiling flamegraphs
gem 'flamegraph', '~> 0.9'
# Stackprof is used by Rack Mini Profiler for call-stack profiling.
gem 'stackprof', '~> 0.2'

# Rack Attack is used to throttle and block spammy and potentially abusive clients.
gem 'rack-attack', '~> 6.3'

# Devise is used to add user authentication.
gem 'devise', '~> 4.7'
# Pundit is used to add user authorization.
gem 'pundit', '~> 2.1'

# Authtrail is used to track Devise user logins and login attempts.
gem 'authtrail', '~> 0.2'
# Ahoy Matey is used to provide local, first party user analytics.
gem 'ahoy_matey', '~> 3.0'
# Ahoy Email is used to provide local, first party email analytics.
gem 'ahoy_email', '~> 1.1'

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

  # Rubocop is a static code analyzer and linter for Ruby code.
  gem 'rubocop', '~> 0.92', require: false
  # Rubocop Rails adds Rubocop checks for Rails applications.
  gem 'rubocop-rails', '~> 2.8', require: false
  # Rubocop RSpec adds Rubocop checks for RSpec tests.
  gem 'rubocop-rspec', '~> 1.43', require: false
  # Rubocop Rake adds Rubocop checks for Rake tasks.
  gem 'rubocop-rake', '~> 0.5', require: false
  # Rubocop Performance adds Rubocop checks for performance concerns.
  gem 'rubocop-performance', '~> 1.8', require: false
  # Rubocop Thread Safety adds Rubocop checks for thread safety concerns.
  gem 'rubocop-thread_safety', '~> 0.4', require: false

  # Bullet is used to detect N+1 database queries.
  gem 'bullet', '~> 6.1'

  # Brakeman uses static analysis to check for security vulnerabilities.
  gem 'brakeman', '~> 4.10'
  # Bundler Audit is used to check for known, vulnerable versions of gems.
  gem 'bundler-audit', '~> 0.7'
  # Bundler Leak is used to check for known memory leaks in gems.
  gem 'bundler-leak', '~> 0.2'

  # Slim Lint adds a linter for the Slim templating language.
  gem 'slim_lint', '~> 0.20'

  # Overcommit is used to install and configure Git hooks.
  gem 'overcommit', '~> 0.57'
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

  # Annotate automatically adds a comment of the database schema to the top of relevant classes/files.
  gem 'annotate', '~> 3.1'

  # Letter Opener is used to open sent emails in the browser directly, instead of sending them.
  gem 'letter_opener', '~> 1.7'
end

group :test do
  # Capybara is used to simulate how a real user interacts with webpages and can run Javascript.
  gem 'capybara', '~> 3.33'
  # Selenium Webdriver is used by Capybara to run Javascript.
  gem 'selenium-webdriver', '~> 3.142'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
