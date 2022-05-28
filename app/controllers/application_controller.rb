class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include JSONAPI::Errors

  skip_before_action :verify_authenticity_token

  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :remove_cookies_action

  # Secure the application
  before_action :authenticate_person!

  #  based on current_user
  before_action :set_paper_trail_whodunnit

  around_action :application_time_zone

  # Tell pundit to use the current person
  def pundit_user
    current_person
  end

  def user_for_paper_trail
    current_person ? current_person.name : 'Anon user'
  end

  def application_time_zone(&block)
    app_time_zone = ENV['TIME_ZONE'] || 'UTC'

    Time.use_zone(app_time_zone, &block)
  end

  def prevent_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized(e)
    # should be 403, need a redirect ????
    error = { status: '403', title: e.message }
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

  protected

  def configure_permitted_parameters
    added_attrs = %i[username email password password_confirmation remember_me email_addresses_attributes]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs

    devise_parameter_sanitizer.permit(:sign_in) do |person|
      person.permit(
        :username,
        :password, # password_confirmation remember_me
        # :email_addresses_attributes,
        email_addresses_attributes: [:email]
      )
    end
  end

  def render_jsonapi_internal_server_error(exception)
    # Rails.logger.error "**** INTERNAL ERROR #{exception.class}"
    Rails.logger.error exception.message if Rails.env.development?
    Rails.logger.error exception.backtrace.join("\n\t") if Rails.env.development?
    # NOTE: if we have a central log put it in here
    super(exception)
  end
end
