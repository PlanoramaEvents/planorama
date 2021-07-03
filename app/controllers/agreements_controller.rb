class AgreementsController < ResourceController
  SERIALIZER_CLASS = 'AgreementSerializer'.freeze
  POLICY_CLASS = 'AgreementsPolicy'.freeze

  def paginate
    false
  end

  # list agreements that I have not signed
  def unsigned
    authorize model_class, policy_class: policy_class

    agreements = Agreement.unsigned(person: current_person)

    render json: agreements,
           each_serializer: serializer_class,
           root: 'data',
           include: serializer_includes,
           adapter: :json,
           content_type: 'application/json'
  rescue => ex
    Rails.logger.error ex.message if Rails.env.development?
    Rails.logger.error ex.backtrace.join("\n\t") if Rails.env.development?
    render status: :bad_request, json: {error: ex.message}
  end

  # list agreements that I have signed
  def signed
    authorize model_class, policy_class: policy_class

    agreements = Agreement.unsigned(person: current_person)

    render json: agreements,
           each_serializer: serializer_class,
           root: 'data',
           include: serializer_includes,
           adapter: :json,
           content_type: 'application/json'
  rescue => ex
    Rails.logger.error ex.message if Rails.env.development?
    Rails.logger.error ex.backtrace.join("\n\t") if Rails.env.development?
    render status: :bad_request, json: {error: ex.message}
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
  rescue => ex
    Rails.logger.error ex.message if Rails.env.development?
    Rails.logger.error ex.backtrace.join("\n\t") if Rails.env.development?
    render status: :bad_request, json: {error: ex.message}
  end

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
