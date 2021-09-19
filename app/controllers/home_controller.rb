class HomeController < ApplicationController
  skip_before_action :authenticate_person!

  def index
  end

end
