# frozen_string_literal: true

# The User model that can be signed in/out, may have pages, may be an admin, etc.
# This controller specifies application-specific overides of devise's user authentication handling of passwords.
class Users::PasswordsController < Devise::PasswordsController
  skip_after_action :verify_authorized # Never perform user authorization during authentication!

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
