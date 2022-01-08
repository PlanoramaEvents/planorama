require 'truemail'

Truemail.configure do |config|
  config.verifier_email = ENV['PROGRAM_EMAIL'] || ENV['SMTP_USER_NAME'] || 'verifier@planorama.online'
end
