# frozen_string_literal: true

# Controls which users are allowed to perform which actions on the CalendarEvent model.
class CalendarPolicy < ApplicationPolicy
  # Anyone can view the list of all calendars.
  def index?
    true
  end

  # Anyone can view a calendar.
  def show?
    true
  end

  # Only signed in users can create a calendar.
  def create?
    (not user.nil?)
  end

  # Only the calendar's creator or admin users can update a calendar.
  def update?
    (record.user.id == user.id) or user.try(:admin?)
  end

  # Only the calendar's creator or admin users can destroy a calendar.
  def destroy?
    (record.user.id == user.id) or user.try(:admin?)
  end
end
