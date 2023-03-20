class People::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  #
  # POST /auth
  # TODO: check email is unique for login when sign up
  # TODO: verification of CAPTCHA token, then delegate to usual path

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      register_success
    else
      register_failed
    end
  end

  def register_success
    render json: { message: 'Succesful sign up.' }
  end

  def register_failed
    render json: { message: 'Something went wrong with the sign up.' }
  end
end
