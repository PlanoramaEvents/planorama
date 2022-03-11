class SettingsController < ApplicationController
  skip_before_action :authenticate_person!

  #
  # Return a JSON array of the settings
  #
  def index
    # 1. model information
    Rails.application.eager_load! # for apps that do dynamic loading so we have all the classes
    clazzes = ApplicationRecord.descendants.collect(&:name).collect{|c| c.constantize}
    enums = {}
    clazzes.each do |c|
      if c.defined_enums.size > 0
        enums[c.name] = c.defined_enums.transform_values{|v| v.values }
      end
    end

    # 2. Aagreement Types
    # 3. list of configs
    settings = {
      # mdl: ApplicationRecord.descendants.collect(&:name),
      enums: enums,
      # TODO: move agreement types to DB
      # At the moment we have 2 types of agreement
      agreement_types: [
        'Terms and Conditions',
        'Privacy Agrement'
      ],
      configs: ::Configuration.all
    }

    render json: settings,
           adapter: :json,
           content_type: 'application/json'
  end

end
