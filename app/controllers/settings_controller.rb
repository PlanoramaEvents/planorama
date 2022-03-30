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

    settings = {
      # 1. model information
      enums: enums,
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
      exclusions: ::Exclusion.all # TODO: we may want a sort order on these ????
    }

    render json: settings,
           adapter: :json,
           content_type: 'application/json'
  end
end
