class SettingsController < ApplicationController
  skip_before_action :authenticate_person!

  #
  # Return a JSON array of the settings
  #
  def index
    # 1. model information
    # 2. Aagreement Types
    # 3. list of configs
    settings = {
      models: {},
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
