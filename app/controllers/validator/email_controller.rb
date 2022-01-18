#
#
#
class Validator::EmailController < ApplicationController
  # JSON validation of one or more email addresses
  def validate
    # access control to do
    # Rails.logger.debug "******* #{permitted}"
    emails_to_validate = permitted
    # Rails.logger.debug "******* #{permitted} -- #{emails_to_validate}"
    emails_we_have = EmailAddress.all.collect(&:email)

    good = emails_to_validate.intersection emails_we_have
    bad = emails_to_validate.difference good

    render json: {
      valid: good,
      invalid: bad
    }, content_type: 'application/json'
  end

  def permitted
    params.require(:emails)
  end
end
