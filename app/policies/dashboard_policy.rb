# frozen_string_literal: true

# Controls which users are allowed to view the dashboard.
DashboardPolicy = Struct.new(:user, :dashboard) do
  # Only admin users can view the dashboard.
  def index?
    user&.admin?
  end
end
