namespace :parameters do
  desc "Create values for the parameter names"
  task seed_names: :environment do

    unless ParameterName.find_by(parameter_name: 'email_from_address')
      ParameterName.create!(
        {
          parameter_name: 'email_from_address',
          parameter_description: 'From email address, check the rest of the mail server requirements as this may need to match.'
        }
      )
    end

    unless ParameterName.find_by(parameter_name: 'email_reply_to_address')
      ParameterName.create!(
        {
          parameter_name: 'email_reply_to_address',
          parameter_description: 'Email address to put in the reply to field.'
        }
      )
    end

  end
end
