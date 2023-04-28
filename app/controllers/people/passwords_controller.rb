# frozen_string_literal: true

class People::PasswordsController < Devise::PasswordsController
  respond_to :json

  before_action :set_redirect, only: [:create]

  def set_redirect
    RequestStore.store[:redirect] = params[:redirect]
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    redirect_to "/#/login/password-reset?reset_password_token=#{params[:reset_password_token]}&redirect=#{params[:redirect]}"
  end
end
