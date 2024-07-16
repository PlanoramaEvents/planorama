class PersonSyncDataController < ResourceController
  SERIALIZER_CLASS = 'PersonSyncDatumSerializer'.freeze
  POLICY_CLASS = 'PersonSyncDatumPolicy'.freeze
  POLICY_SCOPE_CLASS = 'PersonSyncDatumPolicy::Scope'.freeze
  DEFAULT_SORTBY = 'people.name_sort_by'
  DEFAULT_ORDER = 'asc'.freeze

  # 
  def possible_match_count
    authorize model_class, policy_class: policy_class
    
    render status: :ok,
      json: { total: collection_total }.to_json,
      content_type: 'application/json'
  end

  #
  #
  #
  def match
    model_class.transaction do
      authorize model_class, policy_class: policy_class

      reg_id = params[:reg_id] if params[:reg_id]
      person_id = params[:person_id] if params[:person_id]

      # one of 'assisted' or 'manual'
      reg_match = params[:reg_match] if params[:reg_match]

      raise "Type of match should be 'assisted' or 'manual' you gave '#{reg_match}'" unless ['assisted', 'manual'].include? reg_match
      raise "No reg id, person id, or match type specified" unless reg_id && person_id && reg_match

      # Get the reg sync data
      datum = RegistrationSyncDatum.find_by reg_id: reg_id

      # Get the person
      person = Person.find person_id

      # Update the person with the reg data
      IdentityService.clear_person_reg_info(person: person);
      IdentityService.update_reg_info(person: person, details: datum.raw_info, reg_match: reg_match)
  
      render status: :ok,
        json: { message: "Matched" }.to_json,
        content_type: 'application/json'
    end
  end

  # 
  # Method to dismiss a match
  # POST request, parameters are reg_id and person_id
  #
  def dismiss_match
    model_class.transaction do
      authorize model_class, policy_class: policy_class

      reg_id = params[:reg_id] if params[:reg_id]
      person_id = params[:person_id] if params[:person_id]

      raise "No reg id or person id specified" unless reg_id && person_id

      existing = DismissedRegSyncMatch.find_by reg_id: reg_id, person_id: person_id

      if !existing
        DismissedRegSyncMatch.create!({
          reg_id: reg_id,
          person_id: person_id
        })
    
        # We need to refresh the view on match
        # this can take a few seconds
        MigrationHelpers::PlanoViews.refresh_registration_sync_matches
      end
  
      render status: :ok,
        json: { message: "Dismissed Match" }.to_json,
        content_type: 'application/json'
    end
  end

  # by default get the data that is not already mapped to a person
  def default_scope(query: nil)
    return nil unless query

    # exclude people with no registration_sync_data and/or matched
    query.where('people.reg_id is null and people.id in (select pid from filtered_registration_sync_matches)')
  end

  def select_fields
    PersonSyncDatum.select(
      ::PersonSyncDatum.arel_table[Arel.star],
      'name_sort_by'
    )
  end

  def serializer_includes
    [
      :registration_sync_data
    ]
  end

  # def make_distinct?
  #   true
  # end

  def references
    [
      :primary_email
    ]
  end

  def includes
    [
      :primary_email
    ]
  end
end
