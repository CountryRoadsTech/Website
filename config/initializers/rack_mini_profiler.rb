# frozen_string_literal: true

Rack::MiniProfiler.config.disable_caching = false
Rack::MiniProfiler.config.storage = Rack::MiniProfiler::RedisStore
Rack::MiniProfiler.config.storage_options = { host: ENV['REDIS_HOST'], port: 6379 }
