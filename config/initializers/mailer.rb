Rails.application.config.action_mailer.tap do |action_mailer|
  return if Rails.env.development?

  if Rails.env.test?
    action_mailer.default_url_options = {
      host: "localhost"
    }
  else
    # ensure that the correct portocol is used when generating emails
    protocal = Rails.application.config.force_ssl ? "https" : "http"

    action_mailer.default_url_options = {
      host: ENV["HOSTNAME"],
      protocol: protocal
    }

    action_mailer.delivery_method = :smtp
    action_mailer.tap do |action_mailer|
      action_mailer.raise_delivery_errors = true
      action_mailer.smtp_settings = {
        address:              ENV["SMTP_SERVER"],
        port:                 ENV["SMTP_PORT"],
        user_name:            ENV["SMTP_USER_NAME"],
        password:             ENV["SMTP_PASSWORD"],
        authentication:       "plain",
        enable_starttls_auto: true,
        ssl:                  ENV["SMTP_PORT"].to_i == 465
      }
    end
  end
end
