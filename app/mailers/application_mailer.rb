#
# Changed so that the SMTP settings can be retreived from the config values
# stored in the DB
#
class ApplicationMailer < ActionMailer::Base
  default from: Proc.new { from_email },
          reply_to: Proc.new { reply_to_email },
          delivery_method_options: Proc.new { delivery_options }

  layout 'mailer'

  private

  def from_email
    @from_email ||= Dirac::ConfigurationService.parameter_value('email_from_address')
  end

  def reply_to_email
    @reply_to_email ||= Dirac::ConfigurationService.parameter_value('email_reply_to_address')
  end

  def organizer_notification_email
    @organizer_notification_email ||= Planner::Helpers.event_organizer_notification_email
  end

  def delivery_options
    @delivery_options ||= {
      address: ConfigService.value('smtp__server_address'),
      port: ConfigService.value('smtp__server_port').to_i,
      user_name: ConfigService.value('smtp_server_user_name'),
      password: ConfigService.value('smtp_server_password'),
      authentication: ConfigService.value('smtp_server_authentication_mode').to_sym,
      ssl: ConfigService.value?('smtp_server_ssl'),
      enable_starttls_auto: ConfigService.value?('smtp_server_enable_starttls_auto')
    }
  end
end
