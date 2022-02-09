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

    # See https://api.rubyonrails.org/classes/ActiveSupport/TimeZone.html
    unless ParameterName.find_by(parameter_name: 'convention_timezone')
      ParameterName.create!(
        {
          parameter_name: 'convention_timezone',
          parameter_description: 'Timezone for the convention (use TZInfo subset that Rails understands...).'
        }
      )
    end

    unless ParameterName.find_by(parameter_name: 'max_interest_rank1')
      ParameterName.create!(
        {
          parameter_name: 'max_interest_rank1',
          parameter_description: 'How many interests a participant can rank 1',
          parameter_type: 'Integer'
        }
      )
    end
    unless ParameterName.find_by(parameter_name: 'max_interest_rank2')
      ParameterName.create!(
        {
          parameter_name: 'max_interest_rank2',
          parameter_description: 'How many interests a participant can rank 2',
          parameter_type: 'Integer'
        }
      )
    end
    unless ParameterName.find_by(parameter_name: 'max_interest_rank3')
      ParameterName.create!(
        {
          parameter_name: 'max_interest_rank3',
          parameter_description: 'How many interests a participant can rank 3',
          parameter_type: 'Integer'
        }
      )
    end
  end
end
