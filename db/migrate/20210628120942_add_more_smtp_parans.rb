class AddMoreSmtpParans < ActiveRecord::Migration[6.0]
  def up
    ParameterName.insert_all(
      [
        {
          parameter_name: 'email_from_address',
          parameter_description: 'From email address, check the rest of the mail server requirements as this may need to match.'
        },
        {
          parameter_name: 'email_reply_to_address',
          parameter_description: 'Email address to put in the reply to field.'
        }
      ]
    )
  end

  def down
    ParameterName.delete_by(parameter_name: 'email_from_address')
    ParameterName.delete_by(parameter_name: 'email_reply_to_address')
  end
end
