# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CountryRoadsTech
  # The Rails Application, Rails.application
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files. Capybara is used instead of Rail's default.
    config.generators.system_tests = nil

    # Use Sidekiq to perform async, background jobs.
    config.active_job.queue_adapter = :sidekiq

    # Use Redis to perform caching.
    config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'], pool_size: 5, pool_timeout: 5 }

    # Set the time zone.
    config.time_zone = 'Eastern Time (US & Canada)'
    config.beginning_of_week = :monday

    # The database schema must be dumped as SQL (not Ruby) because of Logidze.
    config.active_record.schema_format = :sql
  end
end
