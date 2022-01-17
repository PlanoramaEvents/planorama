#
# Changed to only use JSON and JWT tokens
#
class People::UnlocksController < Devise::UnlocksController
  respond_to :json

  # def get_session
  #   return current_person
  # end

  private
    def respond_with(resource, _opts = {})
      Rails.logger.debug "********* UNLOCKS RESPONDING"
      super unless resource.id

      if resource.id
        render json: {
          message: 'You are logged in.'
        }, status: :ok
      end
    end
end
