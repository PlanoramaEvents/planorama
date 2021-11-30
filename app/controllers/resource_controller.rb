class ResourceController < ApplicationController
  include JSONAPI::Errors

  before_action :load_resource

  respond_to :json

  include ResourceMethods

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized(e)
    error = { status: '401', title: e.message }
    render jsonapi_errors: [error], status: :unauthorized
  end

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  def record_not_found(e)
    error = { status: '404', title: e.message }
    render jsonapi_errors: [error], status: :not_found
  end

  rescue_from ActiveRecord::ActiveRecordError, with: :processing_error
  rescue_from RuntimeError, with: :processing_error
  def processing_error(e)
    Rails.logger.error e.message if Rails.env.development?
    Rails.logger.error e.backtrace.join("\n\t") if Rails.env.development?

    error = { status: '422', title: e.message, detail: e.full_message, source: e.cause }
    # error = { status: '422', title: e.message, detail: e.cause, source: e.cause }
    render jsonapi_errors: [error], status: :unprocessable_entity
  end

  private

  def render_jsonapi_internal_server_error(exception)
    # Rails.logger.error "**** INTERNAL ERROR #{exception.class}"
    Rails.logger.error exception.message if Rails.env.development?
    Rails.logger.error exception.backtrace.join("\n\t") if Rails.env.development?
    # NOTE: if we have a central log put it in here
    super(exception)
  end
end
