module MailService
  # 1. Invite a person to fill in a survey
  # 2. Schedule confirmation
  # 3. Completed survey - thank you email
  # 4. Informational email

  # TODO - add variable to the survey template to say what state the person's acceptance status should be after they complete the survey
  # QUESTION - should we do this for the invite status as well?

  def self.send_mailing(
    person:,
    mailing:
  )
    content = self.generate_email_content(
      mailing.mail_template,
      {
        person: person,
        survey: mailing.survey
        # survey_url: (base_url && survey) ? (base_url + '/form/' + survey.alias) : '',
      }
    )

    self.send_email(
      to:             person.primary_email,
      subject:        mailing.mail_template.subject,
      title:          mailing.mail_template.title,
      content:        content
    )

    self.post_mail_transition(person: person, mailing: mailing)
  end

  def self.send_email(
    from: nil,
    reply_to: nil,
    to:, cc: nil,
    subject:,
    title:,
    content:,
    person: nil,
    mailing: nil,
    skip_premailer: false
  )
    args = {
      subject:        subject,
      title:          title,
      content_type:   'text/html',
      body:           content
    }

    args[:from] = from if from
    args[:reply_to] = reply_to if reply_to
    args[:to] = to if to
    # TODO: if not test and include cc then we need to get the other emails
    args[:cc] = cc if cc && !mailing&.testrun
    args[:skip_premailer] = skip_premailer if skip_premailer

    mail = ApplicationMailer.new.mail(args)

    mail.deliver

    self.save_mail_history(
      person: person,
      email_status: MailHistory::email_statuses[:sent],
      mailing: mailing,
      mail: mail
    )
  rescue Net::SMTPSyntaxError
    self.save_mail_history(
      person:       person,
      email_status: MailHistory.email_statuses[:failed],
      mailing:      mailing,
      mail: mail
    )
  rescue Net::SMTPServerBusy => error
    raise unless error.message.include?('Recipient address rejected')

    self.save_mail_history(
      person:       person,
      email_status: MailHistory.email_statuses[:failed],
      mailing:      mailing,
      mail: mail
    )
  rescue EOFError
    # this indicates that the email address is not valid
    self.save_mail_history(
      person:       person,
      email_status: MailHistory.email_statuses[:failed],
      mailing:      mailing,
      mail: mail
    )
  end

  # TODO = move to mailer ???
  def self.save_mail_history(
    person:,
    email_status: MailHistory.email_statuses[:sent],
    mailing: nil,
    mail:
  )
    return unless mail
    return if mailing&.testrun

    mail_history = MailHistory.create(
      person:       person,
      mailing:      mailing,
      date_sent:    DateTime.now,
      email_status: email_status,
      email:        mail.to,
      subject:      mail.subject,
      content:      mail.body.to_s
    )
  end

  # TODO - do we need this?
  # def self.get_magic_link(person)
  #   magic_link = generate_magic_link(person)
  #   magic_link
  # end

  def self.post_mail_transition(person: , mailing: nil)
    return unless mailing
    return if mailing.testrun

    to_invite_status = mailing.mail_template.transiton_invite_status
    return unless to_invite_status

    person.invite_status = invite_status
    person.save!
  end

  # Given an email template and a set of argument generate the body for the email
  def self.generate_email_content(template, arguments)
    # This turns thge arguments hash into variables for the ERB
    namespace = ErbNamespace.new(arguments)

    return ERB.new(
      template.content,
      0, "%<>"
    ).result(namespace.get_binding) # pass in a context with the parameters i.e. ruby binding
  end
end
