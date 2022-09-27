#
# Changed so that the SMTP settings can be retreived from the config values
# stored in the DB
#
class ApplicationMailer < ActionMailer::Base
  before_action :convention_name

  default from: Proc.new { from_email },
          reply_to: Proc.new { reply_to_email }

  layout 'mailer'

  private

  def from_email
    @from_email = ConfigService.value('email_from_address') || ENV['PROGRAM_EMAIL'] || ENV['SMTP_USER_NAME']
  end

  def reply_to_email
    @reply_to_email = ConfigService.value('email_reply_to_address') || ENV['PROGRAM_EMAIL'] || ENV['SMTP_USER_NAME']
  end

  def convention_name 
    @convention_name = ConfigService.value('convention_name') || ENV['CONVENTION_NAME']
  end
end
