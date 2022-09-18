class SettingsController < ApplicationController
  skip_before_action :authenticate_person!

  #
  # Return a JSON array of the settings
  #
  def index
    Rails.application.eager_load! # for apps that do dynamic loading so we have all the classes
    clazzes = ApplicationRecord.descendants.collect(&:name).collect{|c| c.constantize}
    enums = {}
    clazzes.each do |c|
      if c.defined_enums.size > 0
        enums[c.name] = c.defined_enums.transform_values{|v| v.values }
      end
    end

    zones = {}
    start_at = ::Configuration.find_by(parameter: "convention_start_time")
    if start_at
      con_time = start_at.parameter_value.to_datetime
    end
    con_time ||= Time.now
    ActiveSupport::TimeZone.all.each do |zone|
      # zones[zone.name] = zone.tzinfo.canonical_zone.name
      # use date of con to get the offset for canonical_zone
      zones[zone.tzinfo.canonical_zone.name] = "(UTC#{zone.at(con_time).formatted_offset}) #{zone.name}"
    end

    convention_name = ConfigService.value('convention_name')

    settings = {
      #
      env: Rails.env,
      # 1. model information
      enums: enums,
      # 2. con wide role types for assignments
      assignment_role_types: SessionAssignmentRoleType.all,
      # 2. sensitive fields etc
      attributes: AccessControlService.attribute_meta_data,
      # 3. Agreement Types
      # TODO: move agreement types to DB
      # At the moment we have 2 types of agreement
      agreement_types: [
        'Terms and Conditions',
        'Privacy Agrement'
      ],
      # 4. list of configs
      configs: ::Configuration.all,
      exclusions: ::Exclusion.all, # TODO: we may want a sort order on these ????
      yesnomaybe: [
        {
          value: 'yes',
          label: 'Yes'
        }, {
          value: 'no',
          label: 'No'
        },
        {
          value: 'maybe',
          label: 'Yes, except for items focused on the topics listed below.'
        },
      ],
      attendance_type: [
        {
          value: 'in person',
          label: "**In-person only:** I am planning to attend #{convention_name} in-person"
        }, {
          value: 'virtual',
          label: "**Virtual only:** I am not planning to attend #{convention_name} in-person, and would like to be a virtual participant on virtual-based items only (via Zoom or similar technology)."
        },
        {
          value: 'hybrid',
          label: "**In-person and virtual:** I am planning to attend #{convention_name} in-person, but would also like to be considered for virtual panels."
        },
      ],
      age_restrictions: ::AgeRestriction.all,
      room_services: ::RoomService.all,
      timezones: zones
    }

    render json: settings,
           adapter: :json,
           content_type: 'application/json'
  end
end
