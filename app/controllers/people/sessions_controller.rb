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
      Rails.logger.debug "******* #{resource.to_json}, #{_opts}"
      super unless resource.id
      render json: { message: 'You are logged in.' }, status: :ok if resource.id
    end

    def respond_to_on_destroy
      log_out_success && return if current_person

      log_out_failure
    end

    def log_out_success
      render json: { message: "You are logged out." }, status: :ok
    end

    def log_out_failure
      render json: { message: "Hmm nothing happened..."}, status: :unauthorized
    end
end
