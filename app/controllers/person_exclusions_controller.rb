class PersonExclusionsController < ResourceController
  SERIALIZER_CLASS = 'PersonExclusionSerializer'.freeze
  POLICY_CLASS = 'PersonExclusionPolicy'.freeze
  POLICY_SCOPE_CLASS = 'PersonExclusionPolicy::Scope'.freeze

  def replace
    exclusions = params[:data][:attributes][:person_exclusions_attributes]

    p = Person.find params[:person_id]
    p.with_lock do
      p.person_exclusions.delete_all # clear out the existing availabilites
      exclusions.each do |exclusion|
        p.person_exclusions.create({
            exclusion_id: exclusion
          })
      end

      render json: PersonSerializer.new(p,
                    {
                      include: [:person_exclusions],
                      params: {
                        domain: "#{request.base_url}",
                        current_person: current_person
                      }
                    }
                  ).serializable_hash(),
             content_type: 'application/json'
    end
  end

  def belongs_to_param_id
    params[:person_id]
  end

  def belong_to_class
    Person
  end

  def belongs_to_relationship
    'person_exclusions'
  end

  def allowed_params
    %i[
      lock_version
      id
      person_id
      exclusion_id
      person_exclusions_attributes
    ]
  end

  def paginate
    false
  end
end
