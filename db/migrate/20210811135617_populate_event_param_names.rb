class PopulateEventParamNames < ActiveRecord::Migration[6.0]
  def up
    ParameterName.insert_all(
      [
        {
          parameter_name: 'event_email',
          parameter_description: 'Email for the event'
        },
        {
          parameter_name: 'event_phone',
          parameter_description: 'Phone for the event'
        },
        {
          parameter_name: 'event_terms_link',
          parameter_description: 'Terms of Service link for the event'
        },
        { 
          parameter_name: 'event_privacy_link',
          parameter_description: 'Privacy Policy link for the event'
        }
      ]
    )
  end

  def down
    ParameterName.delete_by(parameter_name: 'event_email')
    ParameterName.delete_by(parameter_name: 'event_phone')
    ParameterName.delete_by(parameter_name: 'event_temrs_link')
    ParameterName.delete_by(parameter_name: 'event_privacy_link')
  end
end
