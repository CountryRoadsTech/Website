# frozen_string_literal: true

# This job reports exceptions to sentry.io.
class ReportToSentryJob < ApplicationJob
  def perform(event)
    Raven.send_event(event)
  end
end
