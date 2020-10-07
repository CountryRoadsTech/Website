# frozen_string_literal: true

Rack::MiniProfiler.config.disable_caching = false
Rack::MiniProfiler.config.storage_options = { url: ENV['REDIS_URL'] }
Rack::MiniProfiler.config.storage = Rack::MiniProfiler::RedisStore
