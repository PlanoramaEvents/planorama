class RbacController < ApplicationController

  # TODO: we need to add whether the person has access to sensitive information
  def index
    rules = PolicyService::policies_for(person: current_person)
    render json: rules,
           content_type: 'application/json'
  end

end
