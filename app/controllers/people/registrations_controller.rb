class People::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    register_success && return if resource.persisted?

    register_failed
  end

  def register_success
    render json: { message: 'Succesful sign up.' }
  end

  def register_failed
    render json: { message: 'Something went wrong with teh sign up.' }
  end
end
