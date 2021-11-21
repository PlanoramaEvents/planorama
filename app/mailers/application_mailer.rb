#
# Changed so that the SMTP settings can be retreived from the config values
# stored in the DB
#
class ApplicationMailer < ActionMailer::Base
  default from: 'planorama@chicon.org'

  # default from: Proc.new { from_email },
  #         reply_to: Proc.new { reply_to_email }

  layout 'mailer'

  private

  # def from_email
  #   @from_email ||= ConfigService.value('email_from_address')
  # end
  #
  # def reply_to_email
  #   @reply_to_email ||= ConfigService.value('email_reply_to_address')
  # end
end
