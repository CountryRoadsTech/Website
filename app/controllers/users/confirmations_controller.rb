# frozen_string_literal: true

# The User model that can be signed in/out, may have pages, may be an admin, etc.
# This controller specifies application-specific overides of devise's user authentication handling of confirmations.
class Users::ConfirmationsController < Devise::ConfirmationsController
  skip_after_action :verify_authorized # Never perform user authorization during authentication!

  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
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
