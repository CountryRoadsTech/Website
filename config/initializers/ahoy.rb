# frozen_string_literal: true

# Configures Ahoy to use the model's called Visit and Event, not Ahoy's defaults.
class Ahoy::Store < Ahoy::DatabaseStore
  def visit_model
    Visit
  end

  def event_model
    Event
  end
end

# Set to true for JavaScript tracking
Ahoy.api = false

# See https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = true
Ahoy.job_queue = :low

Ahoy.track_bots = true

# The same time period of inactivity logged in users will be logged out.
Ahoy.visit_duration = 30.minutes
