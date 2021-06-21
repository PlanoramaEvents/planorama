class ResourceController < ApplicationController
  before_action :load_resource

  respond_to :json

  include ResourceMethods

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    render status: :bad_request,
           json: {error: 'You are not authorized to perform this action.'}
  end

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  def record_not_found
    render status: :bad_request,
           json: {error: 'Request not record not found or access denied.'}
  end
end
