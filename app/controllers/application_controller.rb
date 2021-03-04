class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception # Enables cross-site request forgery (CSRF) attack protection.
end
