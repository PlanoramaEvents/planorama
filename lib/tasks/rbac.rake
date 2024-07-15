namespace :rbac do
  desc "Create Default RBAC Policies"
  task seed_defaults: :environment do
    cleanup
    create_admin_roles
    create_staff_roles
    create_participant_roles
  end

  def cleanup
    ApplicationRole.where(
      con_roles: ['participant'],
      name: 'Participant_Roles_Default',
      sensitive_access: false
    ).destroy_all
    role = ApplicationRole.where(
      con_roles: ['staff'],
      name: 'Staff_Roles_Default',
      sensitive_access: false
    ).destroy_all
    role = ApplicationRole.where(
      con_roles: ['admin'],
      name: 'Admin_Roles_Default',
      sensitive_access: true
    ).destroy_all
  end

  def create_participant_roles
    role = ApplicationRole.find_or_create_by(
      con_roles: ['participant'],
      name: 'Participant_Roles_Default',
      sensitive_access: false
    )
    role.update_permissions({
      "application_role": {
          "create": false,
          "destroy": false,
          "index": false,
          "show": false,
          "update": false
      },
      "parameter_name": {
          "create": false,
          "destroy": false,
          "index": false,
          "show": false,
          "update": false
      },
      "agreement": {
          "index": true,
          "latest": true,
          "show": true,
          "sign": true,
          "signed": true,
          "unsigned": true,
          "create": false,
          "destroy": false,
          "update": false
      },
      "room": {
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false
      },
      "room_set": {
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false
      },
      "tag": {
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false
      },
      "person_exclusion": {
          "create": false,
          "destroy": false,
          "index": false,
          "show": false,
          "update": false
      },
      "person": {
          "assigned_surveys": true,
          "import": false,
          "index": false,
          "mailed_surveys": false,
          "me": true,
          "show": true,
          "submissions": false,
          "completed_surveys": false,
          "update": true,
          "update_all": false,
          "session_names": false,
          "live_sessions": false,
          "snapshot_schedule": true,
          "create": false,
          "destroy": false,
          "resync_airmeet": false,
          "unlink_registration": false
      },
      "survey": {
          "assign_people": false,
          "show": true,
          "unassign_people": false,
          "create": false,
          "destroy": false,
          "index": false,
          "update": false
      },
      "published_session": {
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false,
          "resync_airmeet": false,
      },
      "availability": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "venue": {
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false
      },
      "mail_history": {
          "create": false,
          "destroy": false,
          "index": false,
          "show": false,
          "update": false
      },
      "email_address": {
          "create": true,
          "destroy": false,
          "index": false,
          "mailed_surveys": false,
          "show": false,
          "update": false
      },
      "session": {
          "take_snapshot": false,
          "delete_snapshot": false,
          "express_interest": true,
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false,
          "update_all": false,
          "schedule_publish": false,
      },
      "format": {
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false
      },
      "tag_context": {
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false
      },
      "convention_role": {
          "create": false,
          "destroy": false,
          "index": false,
          "show": false,
          "update": false
      },
      "area": {
          "index": true,
          "show": true,
          "create": false,
          "destroy": false,
          "update": false
      },
      "session_limit": {
          "create": true,
          "destroy": false,
          "index": false,
          "show": false,
          "update": false
      },
      "configuration": {
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false
      },
      "mailing": {
          "assign_people": false,
          "clone": false,
          "preview": false,
          "schedule": false,
          "unassign_people": false,
          "create": false,
          "destroy": false,
          "index": false,
          "show": false,
          "update": false
      },
      "session_assignment": {
          "unexpress_interest": true,
          "create": true,
          "destroy": false,
          "index": true,
          "show": true,
          "update": true
      },
      "page": {
          "create": false,
          "destroy": false,
          "index": false,
          "show": false,
          "update": false
      },
      "submission": {
          "create": true,
          "delete_all": false,
          "flat": false,
          "show": true,
          "update": true,
          "destroy": false,
          "index": true
      },
      "response": {
          "create": true,
          "destroy": false,
          "index": true,
          "show": true,
          "update": true
      },
      "question": {
          "create": false,
          "destroy": false,
          "index": false,
          "show": false,
          "update": false
      },
      "answer": {
          "create": false,
          "destroy": false,
          "index": false,
          "show": false,
          "update": false
      },
      "schedule_snapshot": {
          "create": false,
          "destroy": false,
          "index": false,
          "show": false,
          "update": false
      },
      "schedule_workflow": {
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false
      },
      "person_schedule_approval": {
          "create": false,
          "destroy": false,
          "index": false,
          "show": false,
          "update": false,
          "fetch": false
      },
      "publication_date": {
          "index": false
      },
      "integration": {
          "publish": false
      },
      "page_content": {
        "create": false,
        "destroy": false,
        "index": true,
        "show": true,
        "update": false
      },
      "curated_tag": {
        "create": false,
        "destroy": false,
        "index": true,
        "show": true,
        "update": false
      },
      "RegistrationSyncDatum": {
          "create": false,
          "destroy": false,
          "index": false,
          "show": false,
          "update": false,
          "people": false,
          "synchronize": false,
          "sync_statistics": false
      }
    })
  end

  def create_staff_roles
    role = ApplicationRole.find_or_create_by(
      con_roles: ['staff'],
      name: 'Staff_Roles_Default',
      sensitive_access: false
    )
    role.update_permissions({
      "application_role": {
          "create": false,
          "destroy": false,
          "index": false,
          "show": false,
          "update": false
      },
      "parameter_name": {
          "create": false,
          "destroy": false,
          "index": false,
          "show": false,
          "update": false
      },
      "agreement": {
          "index": true,
          "latest": true,
          "show": true,
          "sign": true,
          "signed": true,
          "unsigned": true,
          "create": false,
          "destroy": false,
          "update": false
      },
      "room": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "room_set": {
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false
      },
      "tag": {
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false
      },
      "person_exclusion": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "person": {
          "assigned_surveys": false,
          "import": false,
          "index": true,
          "mailed_surveys": true,
          "me": true,
          "show": true,
          "submissions": true,
          "completed_surveys": true,
          "update": true,
          "update_all": true,
          "session_names": true,
          "live_sessions": true,
          "snapshot_schedule": true,
          "create": true,
          "destroy": true,
          "resync_airmeet": false,
          "clyde_sync": false,
          "unlink_registration": true
      },
      "survey": {
          "assign_people": true,
          "show": true,
          "unassign_people": true,
          "create": true,
          "destroy": true,
          "index": true,
          "update": true
      },
      "published_session": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true,
          "resync_airmeet": false,
      },
      "availability": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "venue": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "mail_history": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "email_address": {
          "create": true,
          "destroy": true,
          "index": true,
          "mailed_surveys": false,
          "show": true,
          "update": true
      },
      "session": {
          "take_snapshot": false,
          "delete_snapshot": false,
          "express_interest": true,
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true,
          "update_all": true,
          "schedule_publish": false,
      },
      "format": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "tag_context": {
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false
      },
      "convention_role": {
          "create": false,
          "destroy": false,
          "index": false,
          "show": false,
          "update": false
      },
      "area": {
          "index": true,
          "show": true,
          "create": true,
          "destroy": true,
          "update": true
      },
      "session_limit": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "configuration": {
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false
      },
      "mailing": {
          "assign_people": false,
          "clone": false,
          "preview": false,
          "schedule": false,
          "unassign_people": false,
          "create": false,
          "destroy": false,
          "index": false,
          "show": false,
          "update": false
      },
      "session_assignment": {
          "unexpress_interest": true,
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "page": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "submission": {
          "create": true,
          "delete_all": false,
          "flat": true,
          "show": true,
          "update": true,
          "destroy": false,
          "index": true
      },
      "response": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "question": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "answer": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "report": {
        "assigned_sessions_by_participant": true,
        "participant_do_not_assign_with": false,
        "participant_selections": true,
        "people_and_submissions": true,
        "schedule_accpetance": true,
        "schedule_by_person": true,
        "schedule_by_room_then_time": true,
        "session_selections": true,
        "sessions_with_participants": true,
        "record_stream_permissions": true,
        "moderators": true,
        "mis_matched_envs": true,
        "social_media": true,
        "airmeet_magic_link": true,
        "airmeet_diffs": true,
      },
      "session_report": {
        "panels_with_too_few_people": true,
        "panels_with_too_many_people": true,
        "participants_over_session_limits": true,
        "participants_over_con_session_limits": true,
        "non_accepted_on_schedule": true,
        "invited_accepted_not_scheduled": true,
        "session_with_no_moderator": true,
        "scheduled_session_no_people": true,
        "assigned_sessions_not_scheduled": true,
        "session_copy_edit_status": true,
        "daily_grid": true,
        "streamed_and_recorded": true,
        "session_needs": true
      },
      "schedule_report": {
        "schedule_diff": true
      },
      "program_ops_report": {
        "back_of_badge": true,
        "virtual_people": true,
        "room_signs": true,
        "sign_up_sessions": true,
        "table_tents": true,
        "session_minors": true,
        "user_privileges": false
      },
      "conflict_report": {
        "people_outside_availability": true,
        "people_double_booked": true,
        "back_to_back": true,
        "back_to_back_to_back": true,
        "person_exclusion_conflicts": true,
        "multiple_sessions_in_room": true,
        "all_conflicts": true,
        "all_ignored_conflicts": true
      },
      "session_conflict": {
        "conflicts_with": true,
        "conflicts_for": true,
        "ignore": true
      },
      "schedule_snapshot": {
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false
      },
      "schedule_workflow": {
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false
      },
      "person_schedule_approval": {
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": true,
          "fetch": true
      },
      "publication_date": {
          "index": true
      },
      "integration": {
          "publish": false
      },
      "page_content": {
        "create": false,
        "destroy": false,
        "index": true,
        "show": true,
        "update": false
      },
      "curated_tag": {
        "create": false,
        "destroy": false,
        "index": true,
        "show": true,
        "update": false
      },
      "RegistrationSyncDatum": {
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false,
          "people": true,
          "synchronize": false,
          "sync_statistics": true
      }
    })
  end

  def create_admin_roles
    role = ApplicationRole.find_or_create_by(
      con_roles: ['admin'],
      name: 'Admin_Roles_Default',
      sensitive_access: true
    )
    role.update_permissions({
      "application_role": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "parameter_name": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "agreement": {
          "index": true,
          "latest": true,
          "show": true,
          "sign": true,
          "signed": true,
          "unsigned": true,
          "create": true,
          "destroy": true,
          "update": true
      },
      "room": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "room_set": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "tag": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "person_exclusion": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "person": {
          "assigned_surveys": true,
          "import": true,
          "index": true,
          "mailed_surveys": true,
          "me": true,
          "show": true,
          "submissions": true,
          "completed_surveys": true,
          "update": true,
          "update_all": true,
          "session_names": true,
          "live_sessions": true,
          "snapshot_schedule": true,
          "create": true,
          "destroy": true,
          "resync_airmeet": true,
          "clyde_sync": true,
          "unlink_registration": true
      },
      "survey": {
          "assign_people": true,
          "show": true,
          "unassign_people": true,
          "create": true,
          "destroy": true,
          "index": true,
          "update": true
      },
      "published_session": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true,
          "resync_airmeet": true,
      },
      "availability": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "venue": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "mail_history": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "email_address": {
          "create": true,
          "destroy": true,
          "index": true,
          "mailed_surveys": true,
          "show": true,
          "update": true
      },
      "session": {
          "delete_snapshot": true,
          "take_snapshot": true,
          "express_interest": true,
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true,
          "update_all": true,
          "schedule_publish": true,
      },
      "format": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "tag_context": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "convention_role": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "area": {
          "index": true,
          "show": true,
          "create": true,
          "destroy": true,
          "update": true
      },
      "session_limit": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "configuration": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "mailing": {
          "assign_people": true,
          "clone": true,
          "preview": true,
          "schedule": true,
          "unassign_people": true,
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "session_assignment": {
          "unexpress_interest": true,
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "page": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "submission": {
          "create": true,
          "delete_all": true,
          "flat": true,
          "show": true,
          "update": true,
          "destroy": true,
          "index": true
      },
      "response": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "question": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "answer": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "report": {
        "assigned_sessions_by_participant": true,
        "participant_do_not_assign_with": true,
        "participant_selections": true,
        "people_and_submissions": true,
        "schedule_accpetance": true,
        "schedule_by_person": true,
        "schedule_by_room_then_time": true,
        "session_selections": true,
        "sessions_with_participants": true,
        "record_stream_permissions": true,
        "moderators": true,
        "mis_matched_envs": true,
        "social_media": true,
        "airmeet_magic_link": true,
        "airmeet_diffs": true,
      },
      "session_report": {
        "panels_with_too_few_people": true,
        "panels_with_too_many_people": true,
        "participants_over_session_limits": true,
        "participants_over_con_session_limits": true,
        "non_accepted_on_schedule": true,
        "invited_accepted_not_scheduled": true,
        "session_with_no_moderator": true,
        "scheduled_session_no_people": true,
        "assigned_sessions_not_scheduled": true,
        "session_copy_edit_status": true,
        "daily_grid": true,
        "streamed_and_recorded": true,
        "session_needs": true
      },
      "conflict_report": {
        "people_outside_availability": true,
        "people_double_booked": true,
        "back_to_back": true,
        "back_to_back_to_back": true,
        "person_exclusion_conflicts": true,
        "multiple_sessions_in_room": true,
        "all_conflicts": true,
        "all_ignored_conflicts": true
      },
      "schedule_report": {
        "schedule_diff": true
      },
      "program_ops_report": {
        "back_of_badge": true,
        "virtual_people": true,
        "room_signs": true,
        "sign_up_sessions": true,
        "table_tents": true,
        "session_minors": true,
        "user_privileges": true
      },
      "session_conflict": {
        "conflicts_with": true,
        "conflicts_for": true,
        "ignore": true
      },
      "schedule_snapshot": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "schedule_workflow": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
      },
      "person_schedule_approval": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true,
          "fetch": true
      },
      "publication_date": {
          "index": true
      },
      "integration": {
          "publish": true
      },
      "page_content": {
        "create": true,
        "destroy": true,
        "index": true,
        "show": true,
        "update": true
      },
      "curated_tag": {
        "create": true,
        "destroy": true,
        "index": true,
        "show": true,
        "update": true
      },
      "RegistrationSyncDatum": {
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true,
          "people": true,
          "synchronize": true,
          "sync_statistics": true
      },
      "PersonSyncDatum": {
          "index": true,
          "show": true,
          "dismiss_match": true,
          "match": true,
          "possible_match_count": true
      }
    })
  end
end
