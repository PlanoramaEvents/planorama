import { personModel } from '@/store/person.store';

export const personSubmissionMixin = {
  methods: {
    getSurveysForPerson(person) {
      // todo this needs an endpoint
      // for now, just return empty
      return Promise.resolve([])
      // test data
      // return Promise.resolve([{name: "Survey 1", id: "survey1"}, {name: "Survey 2", id: "survey2"}])
    },
  }
}
