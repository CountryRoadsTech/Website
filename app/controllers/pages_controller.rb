# This controller is used to create static pages not backed by a database model.
class PagesController < ApplicationController
  def home
    authorize :pages, :home?
  end

  def about
    authorize :pages, :about?
  end

  def admin
    authorize :pages, :admin?
  end
end
