class PopulateSmtpParamNames < ActiveRecord::Migration[6.0]
  def up
    ParameterName.insert_all(
      [
        {
          parameter_name: 'smtp__server_address',
          parameter_description: 'Address of SMTP server'
        },
        {
          parameter_name: 'smtp__server_port',
          parameter_description: 'Post to use for posting messages'
        },
        {
          parameter_name: 'smtp_server_user_name',
          parameter_description: 'User name to authenticate with SMTP server'
        },
        {
          parameter_name: 'smtp_server_password',
          parameter_description: 'Password to authenticate with SMTP server'
        },
        {
          parameter_name: 'smtp_server_authentication_mode',
          parameter_description: "Authentication mode. One of 'plain', 'login' or 'cram_md5'"
        },
        {
          parameter_name: 'smtp_server_ssl',
          parameter_description: 'Boolean to indicate enable SSL/TLS'
        },
        {
          parameter_name: 'smtp_server_enable_starttls_auto',
          parameter_description: 'Boolean to detect if STARTTLS is enabled in your SMTP server and starts to use it, default should be true'
        }
      ]
    )
  end

  def down
    ParameterName.delete_by(parameter_name: 'smtp__server_address')
    ParameterName.delete_by(parameter_name: 'smtp__server_port')
    ParameterName.delete_by(parameter_name: 'smtp_server_user_name')
    ParameterName.delete_by(parameter_name: 'smtp_server_password')
    ParameterName.delete_by(parameter_name: 'smtp_server_authentication_mode')
    ParameterName.delete_by(parameter_name: 'smtp_server_ssl')
    ParameterName.delete_by(parameter_name: 'smtp_server_enable_starttls_auto')
  end
end
