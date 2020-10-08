# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = {
    host: ENV['REDIS_FOR_SIDEKIQ_HOST'],
    port: ENV['REDIS_FOR_SIDEKIQ_PORT'] || '6379'
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    host: ENV['REDIS_FOR_SIDEKIQ_HOST'],
    port: ENV['REDIS_FOR_SIDEKIQ_PORT'] || '6379'
  }
end
