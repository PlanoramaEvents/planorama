class RbacController < ApplicationController

  def index
    rules = PolicyService::policies_for(person: current_person)
    # access to sensitive information
    rules[:sensitive_access] = false
    render json: rules,
           content_type: 'application/json'
  end

end
