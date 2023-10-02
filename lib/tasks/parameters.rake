namespace :parameters do
  desc "Create values for the parameter names"
  task seed_names: :environment do

    unless ParameterName.find_by(parameter_name: 'email_from_address')
      ParameterName.create!(
        {
          parameter_name: 'email_from_address',
          parameter_description: 'From email address, check the rest of the mail server requirements as this may need to match.',
          parameter_type: 'Email'
        }
      )
    end

    unless ParameterName.find_by(parameter_name: 'email_reply_to_address')
      ParameterName.create!(
        {
          parameter_name: 'email_reply_to_address',
          parameter_description: 'Email address to put in the reply to field.',
          parameter_type: 'Email'
        }
      )
    end

    # See https://api.rubyonrails.org/classes/ActiveSupport/TimeZone.html
    unless ParameterName.find_by(parameter_name: 'convention_timezone')
      ParameterName.create!(
        {
          parameter_name: 'convention_timezone',
          parameter_description: 'Timezone for the convention (use TZInfo subset that Rails understands...).',
          parameter_type: 'Timezone'        }
      )
    end

    unless ParameterName.find_by(parameter_name: 'convention_start_time')
      ParameterName.create!(
        {
          parameter_name: 'convention_start_time',
          parameter_description: 'Start date and time for the convention.',
          parameter_type: 'DateTime'        }
      )
    end

    unless ParameterName.find_by(parameter_name: 'convention_end_time')
      ParameterName.create!(
        {
          parameter_name: 'convention_end_time',
          parameter_description: 'End date and time for the convention.',
          parameter_type: 'DateTime'        }
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

    unless ParameterName.find_by(parameter_name: 'convention_name')
      ParameterName.create!(
        {
          parameter_name: 'convention_name',
          parameter_description: 'The name of the convetion',
          parameter_type: 'String'
        }
      )
    end

    unless ParameterName.find_by(parameter_name: 'privacy_policy_link')
      ParameterName.create!(
        {
          parameter_name: 'privacy_policy_link',
          parameter_description: 'A link to the privacy policy for this convention',
          parameter_type: 'String'
        }
      )
    end

    unless ParameterName.find_by(parameter_name: 'terms_of_use_link')
      ParameterName.create!(
        {
          parameter_name: 'terms_of_use_link',
          parameter_description: 'A link to the planorama terms of use for this convention',
          parameter_type: 'String'
        }
      )
    end

    unless ParameterName.find_by(parameter_name: 'event_virtual')
      ParameterName.create!(
        {
          parameter_name: 'event_virtual',
          parameter_description: 'This should be true if your event is virtual or hybrid',
          parameter_type: 'Boolean'
        }
      )
    end
  end
end
