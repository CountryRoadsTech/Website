# frozen_string_literal: true

# This is the user authentication controller that handles unlocking a locked account.
# It inherits from Devise's default UnlocksController.
class Users::UnlocksController < Devise::UnlocksController
  # Don't ensure user authorization was performed, as it is handled internally by Devise.
  skip_after_action :verify_authorized

  # GET /unlock/new
  # def new
  #   super
  # end

  # POST /unlock
  # def create
  #   super
  # end

  # GET /unlock?unlock_token=abcdef
  # def show
  #   super
  # end

  # protected

  # The path used after sending unlock password instructions
  # def after_sending_unlock_instructions_path_for(resource)
  #   super(resource)
  # end

  # The path used after unlocking the resource
  # def after_unlock_path_for(resource)
  #   super(resource)
  # end
end
