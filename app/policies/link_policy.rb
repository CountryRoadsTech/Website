# frozen_string_literal: true

# Controls which users are allowed to perform which actions on the Link model.
class LinkPolicy < ApplicationPolicy
  # Anyone can view the list of all links.
  def index?
    true
  end

  # Anyone can view a link.
  def show?
    true
  end

  # Only signed in users can create a link.
  def create?
    (not user.nil?)
  end

  # Only the link's creator or admin users can update a link.
  def update?
    (record.user&.id == user&.id) or user&.admin?
  end

  # Only the link's creator or admin users can destroy a link.
  def destroy?
    (record.user&.id == user&.id) or user&.admin?
  end
end
