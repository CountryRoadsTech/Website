# This class is responsible for controlling which visitors are allowed to view which static pages.
PagesPolicy = Struct.new(:user, :pages) do
  # All users can visit /home
  def home?
    true
  end

  # All users can visit /about
  def about?
    true
  end

  # Only admin users can visit /admin
  def admin?
    user.try(:admin?)
  end
end
