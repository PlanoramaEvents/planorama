# frozen_string_literal: true

class People::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  # TODO remove this in 0.3
  protect_from_forgery except: [:destroy, :create]

  # The below line is the one i really needed
  # Leaving the rest of the comments in in case we need some of those things in the future
  respond_to :json

  def get_session
    return current_person
  end

  # GET /resource/sign_in
  #def new
  #  super
  #end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
