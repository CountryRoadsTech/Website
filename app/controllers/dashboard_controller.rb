# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    authorize :dashboard, :index? # Ensure the user is allowed to perform this action.

    @pages = Page.all
    @users = User.all
    @visits = Visit.all
    @events = Event.all
    @sent_emails = SentEmail.all
    @login_activities = LoginActivity.all
  end
end
