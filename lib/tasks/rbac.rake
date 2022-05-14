namespace :rbac do
  desc "Create Default RBAC Policies"
  task seed_defaults: :environment do

    create_admin_roles
    create_staff_roles
    create_participant_roles
  end

  def create_participant_roles
    role = ApplicationRole.create(
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
          "update": true,
          "update_all": false,
          "create": false,
          "destroy": false
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
          "update": false
      },
      "availability": {
          "create": true,
          "destroy": false,
          "index": false,
          "show": false,
          "update": false
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
          "express_interest": true,
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false
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
          "show": false,
          "update": false,
          "destroy": false,
          "index": false
      },
      "response": {
          "create": true,
          "destroy": false,
          "index": false,
          "show": false,
          "update": false
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
      }
    })
  end

  def create_staff_roles
    role = ApplicationRole.create(
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
          "update": true,
          "update_all": true,
          "create": true,
          "destroy": true
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
          "update": true
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
          "express_interest": true,
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
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
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false
      },
      "submission": {
          "create": true,
          "delete_all": false,
          "flat": true,
          "show": true,
          "update": false,
          "destroy": false,
          "index": true
      },
      "response": {
          "create": true,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false
      },
      "question": {
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false
      },
      "answer": {
          "create": false,
          "destroy": false,
          "index": true,
          "show": true,
          "update": false
      }
    })
  end

  def create_admin_roles
    role = ApplicationRole.create(
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
          "update": true,
          "update_all": true,
          "create": true,
          "destroy": true
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
          "update": true
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
          "express_interest": true,
          "create": true,
          "destroy": true,
          "index": true,
          "show": true,
          "update": true
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
      }
    })
  end
end
