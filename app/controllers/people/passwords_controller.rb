# frozen_string_literal: true

class People::PasswordsController < Devise::PasswordsController
  respond_to :json
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    redirect_to "/#/login/password-reset?reset_password_token=#{params[:reset_password_token]}"
  end

  # If we do not match the person then we do a create, which is wrong
  def create
    # redirect_to "/"
    render status: 400, json: { message: 'Unable to reset/create password/person.' }
  end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
