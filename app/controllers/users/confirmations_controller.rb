# frozen_string_literal: true

# This is the user authentication controller that handles email confirmations.
# It inherits from Devise's default ConfirmationsController.
class Users::ConfirmationsController < Devise::ConfirmationsController
  # Don't ensure user authorization was performed, as it is handled internally by Devise.
  skip_after_action :verify_authorized

  # GET /confirmation/new
  # def new
  #   super
  # end

  # POST /confirmation
  # def create
  #   super
  # end

  # GET /confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
