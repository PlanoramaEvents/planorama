class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Secure the application

  # def application_time_zone(&block)
  #   cfg = SiteConfig.first # for now we only have one convention... change when we have many
  #   zone = cfg ? cfg.time_zone : Time.zone
  #   Time.use_zone(zone, &block)
  # end

  # def load_configs
  #   mail_cfg = MailConfig.first
  #   if mail_cfg
  #     Devise.setup do |config|
  #       config.mailer_sender = mail_cfg.from
  #     end
  #   end
  # end
  protected

  def configure_permitted_parameters
    added_attrs = %i[username email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
