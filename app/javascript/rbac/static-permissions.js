export const policies = {
  agreements: {
    index: true,
    latest: true,
    show: true,
    signed: true,
    unsigned: true,
    sign: true,
  },
  survey_submissions: {
    create: true,
    flat: true,
    delete_all: true,
    update: true,
    show: true
  },
  survey: {
    show: true,
    assign_people: true,
    unassign_people: true,
  },
  application: {
    initialize: true,
    index: false,
    show: false,
    create: false,
    new: false,
    update: false,
    edit: false,
    destroy: false
  },
  areas: {
    index: true,
    show: true
  },
  availablities: {
    index: true,
    create: true,
    update: true,
    show: true,
    destroy: true,
  }
}
