# frozen_string_literal: true

# This is the user authentication controller that handles user's passwords.
# It inherits from Devise's default PasswordsController.
class Users::PasswordsController < Devise::PasswordsController
  # Don't ensure user authorization was performed, as it is handled internally by Devise.
  skip_after_action :verify_authorized

  # GET /password/new
  # def new
  #   super
  # end

  # POST /password
  # def create
  #   super
  # end

  # GET /password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /password
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
