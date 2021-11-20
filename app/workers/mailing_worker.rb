class MailingWorker
  include Sidekiq::Worker
  # sidekiq_options retry: true

  def perform(mailing_id, send_test: false, test_address: nil, test_person_id: nil)
    Sidekiq.logger.info "****** Starting mailing for #{mailing_id}"
    mailing = Mailing.find mailing_id

    Sidekiq.logger.info "****** 1. Starting mailing for #{mailing}"
    mailing.with_lock do
      Sidekiq.logger.info "** Attempting to find and send mailing #{mailing_id}" if Sidekiq.logger
      return unless mailing.scheduled # Check just in case this is a dup

      last_person_index = mailing.last_person_idx
      Sidekiq.logger.info "** Mailing #{mailing.id} is scheduled and will begin sending soon" if Sidekiq.logger
      mailing.people.each_with_index do |person, idx|
        Sidekiq.logger.info "** Mailing at #{idx} and last was #{last_person_index}"
        next unless (last_person_index == -1) || (idx > last_person_index)

        begin
          MailService.send_mailing(
            person: person,
            mailing: mailing,
            # base_url
            #   test_address: nil,
            #   send_test: false
          )
          Sidekiq.logger.info "** Passed mailing '#{mailing.display_name} - #{mailing.id}' to mail service for sending" if Sidekiq.logger

          # note the last person processes so we can continue from there if job stopped and restarted

          mailing.last_person_idx = idx # use a counter
          mailing.save
        rescue => msg
          Sidekiq.logger.error msg if Sidekiq.logger
          # if the problem is that the person does not have an email
          # do not stop the sidekiq process
          raise msg unless person.primary_email.blank?
        end
        sleep 0.2 # For 0.2 second between sending emails
      end

      # When the mailing is done mark the mailing as completed, by "unscheduling"
      mailing.scheduled = false
      mailing.save
      Sidekiq.logger.info "Mailing '#{mailing.display_name} - #{mailing.id}' has finished sending and is now 'unscheduled'" if Sidekiq.logger

      # TODO: notify planners that mailing has completed ...
    end
  end
end
