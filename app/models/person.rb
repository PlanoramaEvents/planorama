class Person < ApplicationRecord
  acts_as_taggable

  has_one :bio, dependent: :delete

  before_destroy :check_if_assigned

  has_many  :programme_assignments, dependent: :destroy
  has_many  :programme_items, through: :programme_assignments

  # We let the publish mechanism do the destroy so that the update service knows what is happening
  has_many  :published_programme_assignments
  has_many  :published_programme_items, through: :published_programme_assignments

  has_many  :person_mailing_assignments
  has_many  :mailings, through: :person_mailing_assignments
  has_many  :mail_histories # , :through => :person_mailing_assignments

  has_many  :survey_responses
  # TODO: add scope for survey id
  # TODO: get list of surveys for this person ...

  has_one :user

  enum acceptance_status: {
    unknown: 'unknown',
    probable: 'probable',
    accepted: 'accepted',
    declined: 'declined'
  }

  enum invitestatus: {
    not_set: 'not_set',
    do_not_invite: 'do_not_invite',
    potential_invite: 'potential_invite',
    invite_pending: 'invite_pending',
    invited: 'invited',
    volunteered: 'volunteered'
  }

  # TODO:
  # - there is talk about having a workflow, including whether a person
  #   is vetted as a programme participant. They could be have declined but
  #   pass vetting and later change their mind. So we do not want to
  #   or need to re-vet...
  #

  private

  # check that the person has not been assigned to program items, if they have then return an error and do not delete
  def check_if_assigned
    if (ProgrammeAssignment.where(person_id: id).count > 0) ||
       (PublishedProgrammeAssignment.where(person_id: id).count > 0)
      raise 'Cannot delete an assigned person'
    end
  end

  # # ----------------------------------------------------------------------------------------------
  # TODO: part of refactor
  # has_one :available_date, :dependent => :delete
  # has_one :person_constraints, :dependent => :delete # THis is the max items per day & conference
  # has_many  :exclusions, :dependent => :delete_all
  # has_many  :excluded_people, :through => :exclusions,
  #           :source => :excludable,
  #           :source_type => 'Person' do
  #             def find_by_source(s)
  #               where(['source = ?', s])
  #             end
  #           end
  # has_many  :excluded_items, :through => :exclusions,
  #           :source => :excludable,
  #           :source_type => "ProgrammeItem" do
  #             def find_by_source(s)
  #               where(['source = ?', s])
  #             end
  #           end
  # # ----------------------------------------------------------------------------------------------
end
