# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Enables protection from cross-site request forgery (CSRF) attacks.
  protect_from_forgery with: :exception

  # Enables user authorization.
  include Pundit
  # Ensure user authorization was performed, except for user authentication controllers.
  after_action :verify_authorized

  rescue_from Pundit::NotAuthorizedError, with: :user_not_allowed

  # Tracks which user made each change.
  before_action :set_paper_trail_whodunnit

  before_action :set_sentry_raven_context

  # Only show the Rack Mini Profiler badge in production environment if the user is an admin.
  before_action :load_rack_mini_profiler

  private

  def user_not_allowed
    flash[:error] = 'You are not allowed to perform this action.'
    redirect_to(request.referer || root_path)
  end

  def set_sentry_raven_context
    Raven.user_context(id: current_user.try(:id))
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def load_rack_mini_profiler
    current_user.try(:admin?) do
      Rack::MiniProfiler.authorize_request
    end
  end
end
