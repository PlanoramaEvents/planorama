export const createRbacModel = () => ({
  agreements: {
    label: 'Agreements',
    policies: {
      agreement: {
        label: 'Agreement',
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false
        }
      },
      sign_target_agreement: {
        label: 'Sign Target Agreement',
        perms: {
          create: false,
          view: false,
        }
      },
      view_signed_agreements: {
        label: 'View Signed Agreement',
        perms: {
          view: false,
        }
      },
    }
  },
  rooms: {
    label: "Rooms & Venues",
    policies: {
      room: {
        label: "Room or Venue",
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false,
        }
      },
      assign_room_to_session: {
        label: "Assign Rooms to Session",
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false
        }
      }
    }
  },
  tags: {
    label: "Tags",
    policies: {
      tag: {
        label: "Tag",
        perms: {
          create: false,
          detroy: false,
          view: false,
          update: false
        }
      },
      assign_tag_to_session: {
        label: "Assign Tags to Session",
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false
        }
      },
    }
  },
  people: {
    label: "People",
    policies: {
      person: {
        label: "Person Record",
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false
        },
        scope: {
          person: "all"
        }
      },
      email_addresses: {
        label: "Email Addresses",
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false
        }
      },
      person_on_session: {
        label: "Person on session with",
        perms: {
          view: false
        },
        scope: {
          person: "can_share & on session with, just name/pronouns/primary_email"
        }
      },
      person_me: {
        label: "My Person Record",
        perms: {
          view: true,
          update: true
        },
        scope: {
          person: 'self'
        }
      },
      session_assignment: {
        label: "Assign person to session",
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false
        }
      },
      session_assignment_visible: {
        label: "View assigned visible participants",
        perms: {
          view: false
        },
        scope: {
          session_assignment: "visible"
        }
      },
      sensitive_data: {
        label: "Sensitive Data",
        perms: {
          view: false,
          update: false
        }
      },
      notes: {
        label: "Notes Field & Admin Tab",
        perms: {
          view: false,
          update: false
        }
      }
    }
  },
  schedule: {
    label: "Schdule",
    policies: {
      publish_schedule: {
        label: "Publish Schedule",
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false
        }
      },
      assign_spacetime: {
        label: "Assign Spacetime",
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false
        }
      },
      conflicts: {
        label: "Conflicts",
        perms: {
          view: false
        }
      }
    }
  },
  sessions: {
    label: "Sessions",
    policies: {
      session: {
        label: "Session",
        perms: {
          create: false,
          destroy: false,
          update: false,
          view: false
        }
      },
      published_session: {
        label: "Published Session",
        perms: {
          create: false,
          destroy: false,
          update: false,
          view: true
        }
      },
      format: {
        label: "Session Format",
        perms: {
          create: false,
          destroy: false,
          update: false,
          view: false
        }
      },
      area: {
        label: "Area",
        perms: {
          create: false,
          destroy: false,
          update: false,
          view: false
        }
      }
    }
  },
  admin: {
    label: "Administration",
    policies: {
      event_defaults: {
        label: "Event Defaults",
        perms: {
          create: false,
          destroy: false,
          update: false,
          view: false
        }
      },
      bulk_import: {
        label: "Bulk Import",
        perms: {
          create: false,
          update: false
        }
      }
    }
  },
  mailings: {
    label: "Mailings",
    policies: {
      mailing: {
        label: "Mailing",
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false
        }
      },
      mail_history: {
        label: "Mail History",
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false
        },
        scope: {
          mail_history: "all"
        }
      },
      my_mail_history: {
        label: "My Mail History",
        perms: {
          view: true,
        },
        scope: {
          mail_history: "self"
        }
      },
      assign_mailing: {
        label: "Assign a mailing",
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false,
        }
      },
      send_maling: {
        label: "Send a mailing",
        perms: {
          create: false,
        }
      }
    }
  },
  surveys: {
    label: "Surveys - General",
    policies: {
      survey: {
        label: "Survey",
        perms: {
          create: false,
          view: false,
          update: false,
          delete: false
        },
        scope: {
          survey: "all"
        }
      },
      page: {
        label: "Page",
        perms: {
          create: false,
          view: false,
          update: false,
          delete: false,
        },
        scope: {
          survey: "all"
        }
      },
      question: {
        label: "Question",
        perms: {
          create: false,
          view: false,
          update: false,
          delete: false
        },
        scope: {
          survey: "all"
        }
      },
      answer: {
        label: "Question Option",
        perms: {
          create: false,
          view: false,
          update: false,
          delete: false
        },
        scope: {
          survey: "all"
        }
      },
      submission: {
        label: "Survey Response as a whole",
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false
        },
        scope: {
          submission: "all"
        }
      },
      response: {
        label: "Survey Response - each question",
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false
        },
        scope: {
          response: "all"
        }
      }
    }
  },
  surveys_assigned_to_me: {
    label: "Surveys - assigned to me",
    policies: {
      survey: {
        label: "Survey",
        perms: {
          view: false,
        },
        scope: {
          survey: "assigned to me"
        }
      },
      page: {
        label: "Page",
        perms: {
          view: false,
        },
        scope: {
          survey: "assigned to me"
        }
      },
      question: {
        label: "Question",
        perms: {
          view: false,
        },
        scope: {
          survey: "assigned to me"
        }
      },
      answer: {
        label: "Question Option",
        perms: {
          view: false,
        },
        scope: {
          survey: "assigned to me"
        }
      },
      submission: {
        label: "Survey Response as a whole",
        perms: {
          create: false,
          view: false,
          update: false
        },
        scope: {
          submission: "mine"
        }
      },
      response: {
        label: "Survey Response - each question",
        perms: {
          create: false,
          view: false,
          update: false
        },
        scope: {
          response: "mine"
        }
      }
    }
  },
  menus: {
    label: "Menu links",
    policies: {
      admin: {
        label: "Admin",
        perms: {
          view: false,
        }
      },
      survey: {
        label: "Survey",
        perms: {
          view: false
        }
      },
      people: {
        label: "People",
        perms: {
          view: false
        }
      },
      venues: {
        label: "Venues",
        perms: {
          view: false
        }
      },
      schedule: {
        label: "Schedule",
        perms: {
          view: false,
        }
      },
      sessions: {
        label: "Sessions",
        perms: {
          view: false
        }
      },
      my_profile: {
        label: "My Profile",
        perms: {
          view: false
        }
      }
    }
  }
})
