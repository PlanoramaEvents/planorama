class AboutController < ApplicationController
  skip_before_action :authenticate_person!, only: :terms_of_use

  def terms_of_use
  end
end
