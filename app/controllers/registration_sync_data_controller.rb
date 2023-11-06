class RegistrationSyncDataController < ResourceController
  SERIALIZER_CLASS = 'RegistrationSyncDatumSerializer'.freeze
  POLICY_CLASS = 'RegistrationSyncDatumPolicy'.freeze
  POLICY_SCOPE_CLASS = 'RegistrationSyncDatumPolicy::Scope'.freeze
  DEFAULT_SORTBY = 'registration_sync_data.name'
  DEFAULT_ORDER = 'asc'.freeze

  def people
    authorize model_class, policy_class: policy_class
    datum = RegistrationSyncDatum.find params[:registration_sync_datum_id]

    people = datum.people
    options = {
      params: {
        domain: "#{request.base_url}",
        current_person: current_person
      }
    }

    # return the list of people associated with this datum
    render json: PersonSerializer.new(people,options).serializable_hash(),
           content_type: 'application/json'
  end

  # by default get the data that is not already mapped to a person
  def default_scope(query: nil)
    return nil unless query

    # People that have a potential mapping and not already mapped
    query.where('reg_id not in (select reg_id from people where reg_id is not null)')
         .where('reg_id in (select reg_id from registration_map_counts)')
  end

  def serializer_includes
    [
      :people
    ]
  end

  def includes
    [
      :people
    ]
  end
end
