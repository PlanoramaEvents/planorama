class HomeController < ApplicationController
  skip_before_action :authenticate_person!

  before_action :prevent_cache

  def index
  end

end
