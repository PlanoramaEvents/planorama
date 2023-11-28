#
# Changed to only use JSON and JWT tokens
#
class People::UnlocksController < Devise::UnlocksController
  respond_to :json

  private
  def respond_with(resource, _opts = {})
    redirect_to "/#/login"
  end
end
