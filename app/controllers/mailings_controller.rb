class MailingsController < ResourceController
  SERIALIZER_CLASS = 'MailingSerializer'.freeze
  POLICY_CLASS = 'MailingsPolicy'.freeze

  def serializer_includes
    [
      :mail_template
    ]
  end

  def includes
    [
      :mail_template
    ]
  end

  # before check
  def before_save
    check_editable(mailing: @object)
  end

  def before_update
    check_editable(mailing: @object)
  end

  def check_editable(mailing:)
    raise "Mailing is scheduled, you can not edit it" if mailing.scheduled
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

    # Only schedule a mailing that is not already scheduled
    if mailing.mailing_state == Mailing.mailing_states[:draft]
      mailing.mailing_state == Mailing.mailing_states[:submitted]
      mailing.last_person_idx = -1
      mailing.save!

      MailingWorker.perform_async(mailing.id)
      # TODO
      # MailingWorker.perform(mailing.id, send_test: false, test_address: nil, test_person_id: nil)
    end

    render_object(mailing, includes: false)
  end
end
