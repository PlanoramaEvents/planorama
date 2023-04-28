class HomeController < ApplicationController
  skip_before_action :authenticate_person!

  before_action :prevent_cache

  def index
    if params[:path]
      redirect_to "/#/#{params[:path]}"
    end
  end

end
