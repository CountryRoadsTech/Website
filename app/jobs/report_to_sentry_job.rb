class ReportToSentryJob < ActiveJob::Base
  include Sidekiq::Worker

  queue_as :default

  def perform(event)
    Raven.send_event(event)
  end
end
