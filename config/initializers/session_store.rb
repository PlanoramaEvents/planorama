# Be sure to restart your server when you modify this file.

#
# Force the expire after to use the value that we set in Devise
#
Rails.application.config.session_store :cookie_store,
                                       key: '_planorama_session',
                                       expire_after: Person.remember_for
