class ReportPolicy < BasePolicy

  def mis_matched_envs?
    allowed?(action: :mis_matched_envs)
  end

  def social_media?
    allowed?(action: :social_media)
  end

  def moderators?
    allowed?(action: :moderators)
  end

  def record_stream_permissions?
    allowed?(action: :record_stream_permissions)
  end

  def schedule_accpetance?
    allowed?(action: :schedule_accpetance)
  end

  def people_and_submissions?
    allowed?(action: :people_and_submissions)
  end

  def participant_selections?
    allowed?(action: :participant_selections)
  end

  def session_selections?
    allowed?(action: :session_selections)
  end

  def assigned_sessions_by_participant?
    allowed?(action: :assigned_sessions_by_participant)
  end

  def sessions_with_participants?
    allowed?(action: :sessions_with_participants)
  end

  def schedule_by_person?
    allowed?(action: :schedule_by_person)
  end

  def schedule_by_room_then_time?
    allowed?(action: :schedule_by_room_then_time)
  end

  def participant_do_not_assign_with?
    allowed?(action: :participant_do_not_assign_with)
  end

  def airmeet_magic_link?
    allowed?(action: :airmeet_magic_link)
  end

  def airmeet_diffs?
    allowed?(action: :airmeet_diffs)
  end
end
