class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('MAILGUN_SMTP_LOGIN') { 'from@example.com' }
  layout 'mailer'
end
