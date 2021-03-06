# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

require 'rack/protection' # Use Rack Protection from Sinatra.
use Rack::Protection, instrumenter: ActiveSupport::Notifications
use Rack::Protection::AuthenticityToken
use Rack::Protection::FormToken
use Rack::Protection::RemoteReferrer
use Rack::Protection::EscapedParams
use Rack::Protection::CookieTossing
use Rack::Protection::StrictTransport

run Rails.application
Rails.application.load_server
