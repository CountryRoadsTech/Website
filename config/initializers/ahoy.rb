class Ahoy::Store < Ahoy::DatabaseStore
  # Track user accept language, in addition to default data.
  def track_visit(data)
    data[:accept_language] = request.headers["Accept-Language"]
    super(data)
  end

  def visit_model
    Visit
  end

  def event_model
    Event
  end
end

# Set to true for JavaScript tracking
Ahoy.api = false
# Do track bots.
Ahoy.track_bots = true
# Create a new visit after 30 minutes of inactivity.
Ahoy.visit_duration = 30.minutes
# Report Ahoy errors to Sentry.
Safely.report_exception_method = ->(exception) { Raven.capture_exception(exception) }
