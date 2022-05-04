class FormatsController < ResourceController
  SERIALIZER_CLASS = 'FormatSerializer'.freeze
  POLICY_CLASS = 'FormatsPolicy'.freeze
  POLICY_SCOPE_CLASS = 'FormatsPolicy::Scope'.freeze

  def belongs_to_param_id
    params[:session_id]
  end

  def belong_to_class
    Session
  end

  def belongs_to_relationship
    'session_assignments'
  end

  def paginate
    false
  end
end
