class PlannerController < ApplicationController

  before_action :authenticate_person!
  # before_filter :check_authenticated
  #
  # def check_authenticated
  #   set_return_to request.fullpath
  #   redirect_to '/users/sign_in' unless user_signed_in?
  # end
end
