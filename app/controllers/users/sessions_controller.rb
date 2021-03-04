# frozen_string_literal: true

# The User model that can be signed in/out, may have pages, may be an admin, etc.
# This controller specifies application-specific overides of devise's user authentication handling of sign in/outs.
class Users::SessionsController < Devise::SessionsController
  skip_after_action :verify_authorized # Never perform user authorization during authentication!
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
