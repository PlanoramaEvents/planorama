class ResourceController < ApplicationController
  include JSONAPI::Errors

  before_action :load_resource

  respond_to :json

  include ResourceMethods

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    # render status: :bad_request,
    #        json: {error: 'You are not authorized to perform this action.'}
    render jsonapi_errors: {error: 'You are not authorized to perform this action.'}, status: :unauthorized
  end

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  def record_not_found
    # render status: :bad_request,
    #        json: {error: 'Request record not found or access denied.'}
    render jsonapi_errors: {error: 'Request record not found or access denied.'}, status: :not_found
  end

  private

  def render_jsonapi_internal_server_error(exception)
    Rails.logger.error exception.message if Rails.env.development?
    Rails.logger.error exception.backtrace.join("\n\t") if Rails.env.development?
    # NOTE: if we have a central log put it in here
    super(exception)
  end
end
