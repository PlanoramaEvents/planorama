class ResourceController < ApplicationController
  before_action :load_resource

  respond_to :json

  include ResourceMethods
end
