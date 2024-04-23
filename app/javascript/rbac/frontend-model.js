export const createRbacModel = () => ({
  agreements: {
    label: 'Umowy',
    policies: {
      agreement: {
        label: 'Umowa',
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false
        }
      },
      sign_target_agreement: {
        label: 'Podpisz docelową umowę',
        perms: {
          create: false,
          view: false,
        }
      },
      view_signed_agreements: {
        label: 'Wyświetl podpisane umowy',
        perms: {
          view: false,
        }
      },
    }
  },
  rooms: {
    label: "Pokoje i miejsca",
    policies: {
      room: {
        label: "Pokój lub Miejsce",
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false,
        }
      },
      assign_room_to_session: {
        label: "Przypisz pokoje do sesji",
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
    label: "Tagi",
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
        label: "Przypisz tagi do sesji",
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
    label: "Osoby",
    policies: {
      person: {
        label: "Rekord osoby",
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
        label: "Adresy e-mail",
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false
        }
      },
      person_on_session: {
        label: "Osoba na sesji z",
        perms: {
          view: false
        },
        scope: {
          person: "can_share & on session with, just name/pronouns/primary_email"
        }
      },
      person_me: {
        label: "Mój rekord osoby",
        perms: {
          view: true,
          update: true
        },
        scope: {
          person: 'self'
        }
      },
      session_assignment: {
        label: "Przypisz osobę do sesji",
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false
        }
      },
      session_assignment_visible: {
        label: "Wyświetl przypisanych widocznych uczestników",
        perms: {
          view: false
        },
        scope: {
          session_assignment: "visible"
        }
      },
      sensitive_data: {
        label: "Dane wrażliwe",
        perms: {
          view: false,
          update: false
        }
      },
      notes: {
        label: "Pole notatek i karta Administratora",
        perms: {
          view: false,
          update: false
        }
      }
    }
  },
  schedule: {
    label: "Harmonogram",
    policies: {
      publish_schedule: {
        label: "Opublikuj harmonogram",
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false
        }
      },
      assign_spacetime: {
        label: "Przypisz czas i miejsce",
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false
        }
      },
      conflicts: {
        label: "Konflikty",
        perms: {
          view: false
        }
      }
    }
  },
  sessions: {
    label: "Sesje",
    policies: {
      session: {
        label: "Sesja",
        perms: {
          create: false,
          destroy: false,
          update: false,
          view: false
        }
      },
      published_session: {
        label: "Opublikowana sesja",
        perms: {
          create: false,
          destroy: false,
          update: false,
          view: true
        }
      },
      format: {
        label: "Format sesji",
        perms: {
          create: false,
          destroy: false,
          update: false,
          view: false
        }
      },
      area: {
        label: "Obszar",
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
    label: "Administracja",
    policies: {
      event_defaults: {
        label: "Domyślne wydarzenia",
        perms: {
          create: false,
          destroy: false,
          update: false,
          view: false
        }
      },
      bulk_import: {
        label: "Import masowy",
        perms: {
          create: false,
          update: false
        }
      }
    }
  },
  mailings: {
    label: "Mailingi",
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
        label: "Historia maili",
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
        label: "Moja historia maili",
        perms: {
          view: true,
        },
        scope: {
          mail_history: "self"
        }
      },
      assign_mailing: {
        label: "Przypisz mailing",
        perms: {
          create: false,
          destroy: false,
          view: false,
          update: false,
        }
      },
      send_maling: {
        label: "Wyślij mailing",
        perms: {
          create: false,
        }
      }
    }
  },
  surveys: {
    label: "Ankiety - Ogólne",
    policies: {
      survey: {
        label: "Ankieta",
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
        label: "Strona",
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
        label: "Pytanie",
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
        label: "Opcja pytania",
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
        label: "Odpowiedź na ankietę jako całość",
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
        label: "Odpowiedź na ankietę - każde pytanie",
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
    label: "Ankiety - przypisane do mnie",
    policies: {
      survey: {
        label: "Ankieta",
        perms: {
          view: false,
        },
        scope: {
          survey: "assigned to me"
        }
      },
      page: {
        label: "Strona",
        perms: {
          view: false,
        },
        scope: {
          survey: "assigned to me"
        }
      },
      question: {
        label: "Pytanie",
        perms: {
          view: false,
        },
        scope: {
          survey: "assigned to me"
        }
      },
      answer: {
        label: "Opcja pytania",
        perms: {
          view: false,
        },
        scope: {
          survey: "assigned to me"
        }
      },
      submission: {
        label: "Odpowiedź na ankietę jako całość",
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
        label: "Odpowiedź na ankietę - każde pytanie",
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
    label: "Linki menu",
    policies: {
      admin: {
        label: "Administracja",
        perms: {
          view: false,
        }
      },
      survey: {
        label: "Ankieta",
        perms: {
          view: false
        }
      },
      people: {
        label: "Osoby",
        perms: {
          view: false
        }
      },
      venues: {
        label: "Miejsca",
        perms: {
          view: false
        }
      },
      schedule: {
        label: "Harmonogram",
        perms: {
          view: false,
        }
      },
      sessions: {
        label: "Sesje",
        perms: {
          view: false
        }
      },
      my_profile: {
        label: "Mój profil",
        perms: {
          view: false
        }
      }
    }
  }
})