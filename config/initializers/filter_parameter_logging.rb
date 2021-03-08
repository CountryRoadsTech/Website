# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [
  :email, :unconfirmed_email, :ip, :last_sign_in_ip, :current_sign_in_ip, :city, :context, :country, :ip, :region,
  :user_agent, :latitude, :longitude, :to
]
