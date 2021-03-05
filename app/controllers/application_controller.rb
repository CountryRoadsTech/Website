# frozen_string_literal: true

# All other application controllers inherit from this controller.
# Any behavior here is done across all controllers.
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception # Enables cross-site request forgery (CSRF) attack protection.

  include Pundit # Enables user authorization.
  after_action :verify_authorized # Ensures user authorization was performed in every controller action.

  after_action :log_action

  protected

  def log_action
    ahoy.track 'Ran Action', request.path_parameters
  end
end
