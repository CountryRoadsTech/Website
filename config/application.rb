# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Rail's frameworks used:
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

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load in environment variables from .env files.
Dotenv::Railtie.load

module CountryRoadsTech
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration can go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded after loading
  # the framework and any gems in your application.
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Use Sidekiq as Active Job backend, for performing async tasks.
    config.active_job.queue_adapter = :sidekiq

    # Use Redis as a cache store.
    config.cache_store = :redis_cache_store, { host: ENV['REDIS_HOST'], port: 6379 }

    # Send exceptions to sentry.io.
    Raven.configure do |config|
      config.dsn = ENV['SENTRY_RAVEN_INGEST_URL']
      # Report all exceptions. Ignore Sentry's excluded defaults.
      config.excluded_exceptions = []
      # Send the report asynchronously using ActiveJob.
      config.async = lambda do |event|
        ReportToSentryJob.perform_async(event)
      end
      config.breadcrumbs_logger = [:sentry_logger, :active_support_logger]
      # Only report exceptions in the production environment.
      config.environments = ['production']
      # Sanitize fields sent to sentry.io based on Rail's logger parameter sanitization configuration.
      config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
      # Do send POST request data.
      config.processors -= [Raven::Processor::PostData]
      # Do send cookies.
      config.processors -= [Raven::Processor::Cookies]
    end

    # Include Elasticsearch information in logs.
    require 'elasticsearch/rails/instrumentation'
  end
end
