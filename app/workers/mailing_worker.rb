class MailingWorker
  include Sidekiq::Worker
  # sidekiq_options retry: true

  def perform(mailing_id, send_test = false, test_address = nil, tester_id = nil)
    mailing = Mailing.find mailing_id

    mailing.with_lock do
      if send_test
        send_test_mail(
          mailing: mailing,
          test_address: test_address,
          tester_id: tester_id
        )
      else
        send_mailing(mailing: mailing)
      end
    end
  end

  def send_mailing(mailing:)
    # TODO - if test run then send to the requestor
    return unless mailing.mailing_state == Mailing.mailing_states[:submitted] # Check just in case this is a dup

    last_person_index = mailing.last_person_idx
    mailing.people.each_with_index do |person, idx|
      next unless (last_person_index == -1) || (idx > last_person_index)

      begin
        MailService.send_mailing(
          person: person,
          mailing: mailing
        )

        # If we are sending a test then we do not need to do anything more
        # break if send_test

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
    mailing.mailing_state = Mailing.mailing_states[:sent] #unless send_test
    # mailing.mailing_state = Mailing.mailing_states[:draft] if send_test
    mailing.date_sent = Time.now # unless send_test
    mailing.save
    Sidekiq.logger.info "Mailing '#{mailing.display_name} - #{mailing.id}' has finished sending and is now 'unscheduled'" if Sidekiq.logger

    # TODO: notify planners that mailing has completed ... ??
  end

  def send_test_mail(mailing:, test_address:, tester_id:)
    # find person for test address
    addr = EmailAddress.find_by(email: test_address)
    if addr
      tester = Person.find tester_id

      MailService.send_mailing(
        person: addr.person,
        mailing: mailing,
        tester: tester
      )
    end

    # note the last person processes so we can continue from there if job stopped and restarted
    # mailing.last_person_idx = idx # use a counter
    # mailing.save
  rescue => msg
    Sidekiq.logger.error msg if Sidekiq.logger
    # if the problem is that the person does not have an email
    # do not stop the sidekiq process
    raise msg unless person.primary_email.blank?
  end
end
