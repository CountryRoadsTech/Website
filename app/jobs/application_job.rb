# frozen_string_literal: true

# This is the base async job, that all other jobs in the application inherit from.
class ApplicationJob
  include Sidekiq::Worker
end
