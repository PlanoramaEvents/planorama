class RbacController < ApplicationController

  def index
    rules = PolicyService::policies_for(person: current_person)
    render json: rules,
           content_type: 'application/json'
  end

end
