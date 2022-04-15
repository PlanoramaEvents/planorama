class EmailAddressesController < ResourceController
  MODEL_CLASS = 'EmailAddress'.freeze
  SERIALIZER_CLASS = 'EmailAddressSerializer'.freeze
  POLICY_CLASS = 'EmailAddressesPolicy'.freeze
  POLICY_SCOPE_CLASS = 'EmailAddressesPolicy::Scope'.freeze

  def belongs_to_param_id
    params[:person_id]
  end

  def belong_to_class
    Person
  end

  def belongs_to_relationship
    'email_addresses'
  end

  def paginate
    false
  end

  def allowed_params
    %i[
      id
      lock_version
      email
      isdefault
      is_valid
      person_id
    ]
  end
end
