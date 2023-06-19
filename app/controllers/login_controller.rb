class LoginController < ApplicationController
  skip_before_action :authenticate_person!, only: [:magic_link, :sign_up]

  #
  # Step 1: create account - send email via form to back end and survey
  # Step 2: back end checks email, if not there create a person and sends a magic link with Survey URL
  # Step 3: when person clicks magic link check that they have a password and if not get them to set it
  # Step 4: after password set continue following magic link to survey
  #
  # NOTE: do not let people login with empty password (put check in sign in for this)
  #

  # Step 1: from email create a person
  def sign_up
    email = params[:email]
    url = params[:url]
    captcha_response = params[:captcha_response]

    # recaptcha
    if !ENV['RECAPTCHA_SECRET_KEY'].blank?
      verify_recaptcha!({response: captcha_response, secret_key: ENV['RECAPTCHA_SECRET_KEY']})
    end

    # check that email is not used as primary by anyone
    # if it is then use that person if they do not have a password set
    person = Person.joins(:email_addresses)
                  .where("email_addresses.isdefault = true AND email_addresses.email ILIKE ?", email.strip)
                  .first

    if (person == nil) then
      # create a new person with this as the primnary email
      person = Person.create!(
        name: email,
        email_addresses_attributes: [
          {
            email: email,
            isdefault: true
          }
        ]
      )

      # add Participant role to person
      ConventionRole.create(
        person: person,
        role: ConventionRole.roles[:participant]
      )
    end

    # create a magic link for the person and the given url
    link = MagicLinkService.generate(person_id: person.id, redirect_url: url, valid_for: 48.hours)

    # TODO: send this in a welcome email
    magic_url = if link
                  UrlService.url_for path: "login/#{link.token}"
                else
                  root_path
                end

    # Rails.logger.debug "****** LINK IS #{magic_url}"
    # TODO: if they already have a password ...???
    PersonMailer.with(email: email, url: magic_url).confirm_sign_up_email.deliver_later

    render json: { message: 'Succesful sign up.'}, status: :created
  end

  # Complete the sign up by setting the password
  def complete_sign_up
    token = session[:magic_token] #params[:magic_link]
    person_params = params.permit![:person].to_h

    raise "password and password confirmation do not match" if person_params[:password] != person_params[:password_confirmation]

    # redirect them to the URL that they were going to in the first place
    # if no URL then use the root path
    url = if token
            magic_link = MagicLinkService.decode token: token
            magic_link.url
          else
            root_path
          end

    # set the password AND name for the person
    person = current_person
    person.update!(
      password: person_params[:password],
      name: person_params[:name]
    )

    # Check this is ok - password reset appears to sign person out?
    sign_in(person, bypass:true)
    # sign_in(person, scope: :person)

    # The say it is ok and pass along the redirect
    render json: { message: 'Passsword set.', redirect: url }, status: :ok
  end

  # TODO
  # /magiclink#xxxxx - see if we can load the app with the link etc
  # route takes the link as a param?
  #
  def magic_link
    token = params[:magic_link]

    # decode the link
    magic_link = MagicLinkService.decode token: token

    # find the person
    person = magic_link.person

    # Authenticate the person
    sign_in(person, scope: :person)

    # Direct them the destination page
    # Also set magic link in cookie just in case
    session[:magic_token] = token

    if token && magic_link&.url
      redirect_to magic_link.url
    else
      redirect_to root_path
    end
  end
end
