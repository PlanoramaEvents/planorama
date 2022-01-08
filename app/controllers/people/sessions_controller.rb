#
# Changed to only use JSON and JWT tokens
#
class People::SessionsController < Devise::SessionsController
  respond_to :json

  def get_session
    return current_person
  end

  private
    def respond_with(resource, _opts = {})
      super unless resource.id

      if resource.id
        render json: {
          message: 'You are logged in.'
        }, status: :ok
      end
    end
end
