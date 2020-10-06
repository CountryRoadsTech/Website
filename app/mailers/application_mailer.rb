class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  # Track UTM Parameters on all emails sent.
  track utm_params: true

  # Track if/when the user opens an email and clicks any links.
  track open: true, click: true
end
