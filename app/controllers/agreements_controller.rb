class AgreementsController < ResourceController
  SERIALIZER_CLASS = 'AgreementSerializer'.freeze
  POLICY_CLASS = 'AgreementsPolicy'.freeze

  # need to add includes etc to speed up query
  def allowed_params
    %i[
      lock_version
      target
      title
      terms
      type
      created_by_id
      updated_by_id
      created_at
      updated_at
    ]
  end
end
