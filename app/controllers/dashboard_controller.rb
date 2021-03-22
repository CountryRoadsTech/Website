# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    authorize :dashboard, :index? # Ensure the user is allowed to perform this action.

    @pages = Page.all
    @users = User.all
    @visits = Visit.includes(:user).all
    @events = Event.includes(:user, :visit).all
    @sent_emails = SentEmail.all
    @login_activities = LoginActivity.all
    @calendars = Calendar.all
    @calendar_events = CalendarEvent.all
    @links = Link.all
  end
end
