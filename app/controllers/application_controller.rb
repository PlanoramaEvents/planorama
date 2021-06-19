class ApplicationController < ActionController::Base
  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?

  # Secure the application
  before_action :authenticate_person!

  #  based on current_user
  before_action :set_paper_trail_whodunnit

  # Tell pundit to use the current person
  def pundit_user
    current_person
  end

  # TODO: RBAC
  # TODO: timezone

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

  def user_for_paper_trail
    current_person ? current_person.published_name : 'Anon user'
  end

  protected

  def configure_permitted_parameters
    added_attrs = %i[username email password password_confirmation remember_me email_addresses_attributes]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs

    devise_parameter_sanitizer.permit(:sign_in) do |person|
      person.permit(
        :username,
        :password, # password_confirmation remember_me
        # :email_addresses_attributes,
        email_addresses_attributes: [:email]
      )
    end
  end
end
