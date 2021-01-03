class MailTemplate < ApplicationRecord
  belongs_to :survey
  has_many :mailings

  enum transiton_invite_status: {
    not_set: 'Not Set',
    potential_invite: 'Potential Invite',
    invite_pending: 'Invite Pending',
    voluntered: 'Volunteered'
  }

  enum mail_use: {
    general: 'General',
    invite: 'Invite',
    schedule: 'Schedule',
    completed_survey: 'CompletedSurvey',
    declined_survey: 'DeclinedSurvey'
  }
end
