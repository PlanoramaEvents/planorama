class AvailabilitiesController < ResourceController
  SERIALIZER_CLASS = 'AvailabilitySerializer'.freeze
  POLICY_CLASS = 'AvailabilitiesPolicy'.freeze
  POLICY_SCOPE_CLASS = 'AvailabilitiesPolicy::Scope'.freeze

  def replace
    availabilities = params[:data][:attributes][:availabilities_attributes]

    # Rails.logger.debug "Change availabilites to => #{availabilities}"
    p = Person.find params[:person_id]
    # TODO: check locking
    p.with_lock do

      p.availabilities.delete_all # clear out the existing availabilites
      availabilities.each do |avail|
        p.availabilities.create({
            start_time: avail[:start],
            end_time: avail[:end]
          })
      end

      render json: PersonSerializer.new(p,
                    {
                      include: [:availabilities],
                      params: {
                        domain: "#{request.base_url}",
                        current_person: current_person
                      }
                    }
                  ).serializable_hash(),
             content_type: 'application/json'

    end
  end

  #
  def belongs_to_param_id
    params[:person_id]
  end

  def belong_to_class
    Person
  end

  def belongs_to_relationship
    'availabilities'
  end

  def allowed_params
    %i[
      lock_version
      id
      start_time
      end_time
      person_id
      availabilities_attributes
    ]
  end

  def paginate
    false
  end
end
