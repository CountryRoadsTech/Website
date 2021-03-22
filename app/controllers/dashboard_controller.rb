# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    authorize :dashboard, :index? # Ensure the user is allowed to perform this action.

    @pages_pagination, @pages = pagy(Page.all)
    @users_pagination, @users = pagy(User.all)
    @visits_pagination, @visits = pagy(Visit.includes(:user).all)
    @events_pagination, @events = pagy(Event.includes(:user, :visit).all)
    @sent_emails_pagination, @sent_emails = pagy(SentEmail.all)
    @login_activities_pagination, @login_activities = pagy(LoginActivity.all)
    @calendars_pagination, @calendars = pagy(Calendar.all)
    @calendar_events_pagination, @calendar_events = pagy(CalendarEvent.all)
    @links_pagination, @links = pagy(Link.all)
  end
end
