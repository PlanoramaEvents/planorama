class PersonMailer < ApplicationMailer

  def confirm_sign_up_email
    @url = params[:url]
  end
end
