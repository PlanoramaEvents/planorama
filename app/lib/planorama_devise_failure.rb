class PlanoramaDeviseFailure < Devise::FailureApp
  def respond
    json_error_response
  end

  def json_error_response
    self.status = 401
    self.content_type = "application/json"
    self.response_body = [ { message: 'Authentication Failed' } ].to_json
  end
end
