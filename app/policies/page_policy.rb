# frozen_string_literal: true

# Controls which users are allowed to perform which actions on the Page model.
class PagePolicy < ApplicationPolicy
  # Anyone can view the list of all pages.
  def index?
    true
  end

  # Anyone can view a page.
  def show?
    true
  end

  # Only admin users can create a page.
  def create?
    user.try(:admin?)
  end

  # Only admin users can update a page.
  def update?
    user.try(:admin?)
  end

  # Only admin users can destroy a page.
  def destroy?
    user.try(:admin?)
  end
end
