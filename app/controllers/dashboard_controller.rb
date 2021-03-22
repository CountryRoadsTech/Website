# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    authorize :dashboard, :index? # Ensure the user is allowed to perform this action.

    # Custom pagination params must be given for each model, as multiple pagination views appear on the admin dashboard,
    # and they will override each other if they all use the same params (the global defaults).
    @pages_pagination, @pages = pagy(Page.all,
                                     page_param: :pages_page, items_param: :pages_per_page)
    @users_pagination, @users = pagy(User.all,
                                     page_param: :users_page, items_param: :users_per_page)
    @visits_pagination, @visits = pagy(Visit.includes(:user).all,
                                       page_param: :visits_page, items_param: :visits_per_page)
    @events_pagination, @events = pagy(Event.includes(:user, :visit).all,
                                       page_param: :events_page, items_param: :events_per_page)
    @sent_emails_pagination, @sent_emails = pagy(SentEmail.all,
                                                 page_param: :sent_emails_page, items_param: :sent_emails_per_page)
    @login_activities_pagination, @login_activities = pagy(LoginActivity.all,
                                                           page_param: :login_activities_page,
                                                           items_param: :login_activities_per_page)
    @calendars_pagination, @calendars = pagy(Calendar.all,
                                             page_param: :calendars_page, items_param: :calendars_per_page)
    @calendar_events_pagination, @calendar_events = pagy(CalendarEvent.all,
                                                         page_param: :calendar_events_page,
                                                         items_param: :calendar_events_per_page)
    @links_pagination, @links = pagy(Link.all,
                                     page_param: :links_page, items_param: :links_per_page)
  end
end
