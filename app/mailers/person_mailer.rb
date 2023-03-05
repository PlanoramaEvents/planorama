class PersonMailer < ApplicationMailer

  # PersonMailer.with(email: email, url: magic_url).confirm_sign_up_email.deliver_later
  def confirm_sign_up_email
    @email = params[:email]
    @url = params[:url]

    mail(to: @email, subject: "Welcome to #{convention_name}")
  end
end
