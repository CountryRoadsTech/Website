# frozen_string_literal: true

# Controls which users are allowed to perform which actions on the CalendarEvent model.
class CalendarEventPolicy < ApplicationPolicy
  # Anyone can view the list of all events.
  def index?
    true
  end

  # Anyone can view an event.
  def show?
    true
  end

  # Only signed in users can create a page.
  def create?
    (not user.nil?)
  end

  # Only the events creator or admin users can update an event.
  def update?
    (record.user&.id == user&.id) or user&.admin?
  end

  # Only the events creator or admin users can destroy an event.
  def destroy?
    (record.user&.id == user&.id) or user&.admin?
  end
end
