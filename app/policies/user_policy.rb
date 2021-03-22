# frozen_string_literal: true

# Controls which users are allowed to login as another user.
class UserPolicy < ApplicationPolicy
  # Only admin users can login as another user.
  def masquerade?
    user&.admin?
  end
end
