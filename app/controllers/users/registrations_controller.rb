# frozen_string_literal: true

require 'faker' # Faker is used to generate an avatar for the user.
require 'open-uri'

# The User model that can be signed in/out, may have pages, may be an admin, etc.
# This controller specifies application-specific overrides of devise's user authentication handling of sign ups.
class Users::RegistrationsController < Devise::RegistrationsController
  skip_after_action :verify_authorized # Never perform user authorization during authentication!
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super do |resource|
      # Attach an avatar from robohash.org, if the user decided not to use their own.
      unless resource.avatar.attached?
        resource.avatar.attach(io: URI.parse(Faker::Avatar.image(size: '100x100')).open, filename: 'avatar.png')
        resource.save!
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
