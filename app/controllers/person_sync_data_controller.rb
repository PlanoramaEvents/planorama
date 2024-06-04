class PersonSyncDataController < ResourceController
  SERIALIZER_CLASS = 'PersonSyncDatumSerializer'.freeze
  POLICY_CLASS = 'PersonSyncDatumPolicy'.freeze
  POLICY_SCOPE_CLASS = 'PersonSyncDatumPolicy::Scope'.freeze
  DEFAULT_SORTBY = 'name_sort_by'
  DEFAULT_ORDER = 'asc'.freeze

  # by default get the data that is not already mapped to a person
  def default_scope(query: nil)
    return nil unless query

    # People that have a potential mapping and not already mapped
    query.joins(:registration_sync_data)
      .where('people.reg_id is null')
      .where('registration_sync_data.reg_id in (select reg_id from registration_map_counts)')
  end

  def serializer_includes
    [
      :registration_sync_data
    ]
  end

  def includes
    [
      :email_addresses,
      :registration_sync_data
    ]
  end
end
