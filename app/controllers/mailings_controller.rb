class MailingsController < ResourceController
  SERIALIZER_CLASS = 'MailingSerializer'.freeze

  # TODO: send a mailing
  # need to get sidekiq job done
end
