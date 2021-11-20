class MailingsController < ResourceController
  SERIALIZER_CLASS = 'MailingSerializer'.freeze
  POLICY_CLASS = 'MailingsPolicy'.freeze

  def assign_people
    authorize current_person, policy_class: policy_class
    people_ids = params.permit(people: [:id])

    Survey.transaction do
      mailing = Mailing.find params[:mailing_id]
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
      people = Person.find people_ids.to_h[:people].collect{|a| a[:id] }

      mailing.people.delete people

      render_object(mailing, includes: false)
    end
  end

  # TODO: send a mailing
  # need to get sidekiq job done
  def schedule
    mailing = Mailing.find params[:id]

    mailing.scheduled = true
    mailing.last_person_idx = -1
    mailing.save!

    MailingWorker.perform_async(mailing.id)
    # MailingWorker.perform(mailing.id, send_test: false, test_address: nil, test_person_id: nil)

    render_object(mailing, includes: false)
  end
end
