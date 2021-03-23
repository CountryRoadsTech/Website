# frozen_string_literal: true

# Controls which users are allowed to preform global, site-wide search.
SearchPolicy = Struct.new(:user, :search) do
  # All users are allowed to search.
  def index?
    true
  end
end
