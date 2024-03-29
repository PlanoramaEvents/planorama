class MailingsController < ResourceController
  SERIALIZER_CLASS = 'MailingSerializer'.freeze
  POLICY_CLASS = 'MailingPolicy'.freeze
  DEFAULT_SORTBY = 'updated_at'.freeze
  DEFAULT_ORDER = 'desc'.freeze

  def serializer_includes
    [
      :sent_by
    ]
  end

  def includes
    [
      :sent_by
    ]
  end

  # before check
  # def before_save
  #   check_editable(mailing: @object)
  # end

  def clone
    model_class.transaction do
      authorize @object, policy_class: policy_class

      cloned = @object.deep_clone(
        include: [:person_mailing_assignments],
        except: [ :sent_by_id, :mailing_state ],
        use_dictionary: true
      )

      cloned.save!

      render_object(cloned, includes: false)
    end
  end

  def before_update
    check_editable(mailing: @object)
  end

  def check_editable(mailing:)
    raise "Mailing is scheduled, you can not edit it" unless mailing.mailing_state == Mailing.mailing_states[:draft]
  end

  def after_save
    assign_people_by_email
  end

  def after_update
    assign_people_by_email
  end

  def assign_people_by_email
    emails = if params[:data]
               params[:data][:attributes][:emails]
             else
               params[:emails]
             end

    # get the id od people with those emails
    email_addresses = EmailAddress.where("LOWER(email) in (?)", emails.map(&:downcase))
    people = Person.find email_addresses.collect{|a| a.person_id }

    # remove any that are not in the list but in the mailing
    # add any in the mailing that are not in the list
    @object.people.delete_all

    # add them to the mailing, make sure unique ...
    @object.people << people
  end

  def assign_people
    authorize current_person, policy_class: policy_class
    people_ids = params.permit(people: [:id])

    Survey.transaction do
      mailing = Mailing.find params[:mailing_id]
      check_editable(mailing: mailing)

      people = Person.find people_ids.to_h[:people].collect{|a| a[:id] }

      mailing.people << people

      render_object(mailing, includes: false)
    end
  end

  def unassign_people
    authorize current_person, policy_class: policy_class
    people_ids = params.permit(people: [:id])

    Survey.transaction do
      mailing = Mailing.find params[:mailing_id]
      check_editable(mailing: mailing)

      people = Person.find people_ids.to_h[:people].collect{|a| a[:id] }

      mailing.people.delete people

      render_object(mailing, includes: false)
    end
  end

  def schedule
    mailing = Mailing.find params[:id]
    authorize current_person, policy_class: policy_class

    send_test = params[:test].present?
    test_address = params[:email]

    # Only schedule a mailing that is not already scheduled
    if (mailing.mailing_state == Mailing.mailing_states[:draft]) || send_test
      if !send_test
        mailing.mailing_state = Mailing.mailing_states[:submitted]
        mailing.last_person_idx = -1
        mailing.sent_by = current_person
        mailing.save!
      end

      MailingWorker.perform_async(
        mailing.id,
        send_test,
        test_address,
        (send_test ? current_person.id : nil)
      )
    end

    render_object(mailing, includes: false)
  end

  def preview
    mailing = Mailing.find params[:id]
    authorize current_person, policy_class: policy_class

    recipient_address = params[:email]
    addr = EmailAddress.find_by(email: recipient_address)
    participant_schedule_url = SessionService.participant_schedule_url

    content = MailService.preview_email_content(
                person: addr.person,
                mailing: mailing,
                participant_schedule_url: participant_schedule_url
              )

    # render_object(content) # TODO: verify ok for content
    render json: {
             to: recipient_address,
             subject: mailing.subject,
             content: content
           },
           content_type: 'application/json'

  end

  def except_params
    %i[
      emails
      display_name
    ]
  end

end
