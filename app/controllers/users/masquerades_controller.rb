# frozen_string_literal: true

class Users::MasqueradesController < Devise::MasqueradesController
  protected

  def masquerade_authorize!
    authorize(User, :masquerade?) unless params[:action] == 'back'
  end

  def after_masquerade_path_for(resource)
    flash[:alert] =
      "Successfully signed in as #{resource.name} (#{resource.email}). Press the back button on your browser to sign out of this user."
    super
  end

  def after_back_masquerade_path_for(resource)
    flash[:alert] = "No longer signed in as #{resource.name} (#{resource.email})"
    super
  end
end
