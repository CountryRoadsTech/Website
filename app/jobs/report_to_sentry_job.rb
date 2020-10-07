class ReportToSentryJob < ApplicationJob
  def perform(event)
    Raven.send_event(event)
  end
end
