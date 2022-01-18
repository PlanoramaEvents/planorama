class AgreementsController < ResourceController
  SERIALIZER_CLASS = 'AgreementSerializer'.freeze
  POLICY_CLASS = 'AgreementsPolicy'.freeze

  def paginate
    false
  end

  def before_save
    @object.created_by_id = current_person.id
    @object.updated_by_id = current_person.id
  end

  def before_update
    @object.updated_by_id = current_person.id
  end

  def latest
    authorize model_class, policy_class: policy_class

    agreements = Agreement.latest

    # raise ActiveRecord::RecordNotFound.new('agreement not found') unless agreement
    render json: serializer_class.new(agreements,
                  {
                    include: serializer_includes,
                    params: {domain: "#{request.base_url}"}
                  }
                ).serializable_hash(),
           content_type: 'application/json'
  end

  # list agreements that I have not signed
  def unsigned
    authorize model_class, policy_class: policy_class

    agreements = Agreement.latest.unsigned(person: current_person)

    render json: serializer_class.new(agreements,
                  {
                    include: serializer_includes,
                    params: {domain: "#{request.base_url}"}
                  }
                ).serializable_hash(),
           content_type: 'application/json'
  end

  # list agreements that I have signed
  def signed
    authorize model_class, policy_class: policy_class

    agreements = Agreement.signed(person: current_person)

    render json: serializer_class.new(agreements,
                  {
                    include: serializer_includes,
                    params: {domain: "#{request.base_url}"}
                  }
                ).serializable_hash(),
           content_type: 'application/json'
  end

  # sign a specific agreement
  def sign
    authorize model_class, policy_class: policy_class

    agreement = Agreement.find params[:id]

    existing = PersonAgreement.find_by(
      person_id: current_person.id,
      agreement_id: agreement.id
    )

    if existing
      existing.update(
        signed: true,
        agreed_on: Time.now
      )
    else
      PersonAgreement.create(
        person_id: current_person.id,
        agreement_id: agreement.id,
        signed: true,
        agreed_on: Time.now
      )
    end

    # Agreement.unsigned(person: current_person)
    render_object(agreement)
  end

  # need to add includes etc to speed up query
  def allowed_params
    %i[
      id
      lock_version
      target
      title
      terms
      agreement_type
    ]
  end
end
