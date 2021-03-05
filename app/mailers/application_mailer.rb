# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'users@countryroads.tech'
  layout 'mailer'

  track open: true, click: true
end
