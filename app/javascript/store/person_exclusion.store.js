export const GET_PERSON_EXCLUSIONS = 'GET PERSON EXCLUSIONS';
export const UPDATE_PERSON_EXCLUSIONS = 'UPDATE PERSON EXCLUSIONS';

export const personExclusionModel = 'person_exclusion';

import { personModel } from '@/store/person.store'

export const personExclusionEndpoints = {
  [personExclusionModel]: 'person_exclusion'
}

export const personExclusionStore = {
  actions: {
    [UPDATE_PERSON_EXCLUSIONS] ({dispatch}, {person, params}) {
      // const mdl = {
      //   availabilities_attributes: params,
      //   _jv: {
      //     type: personModel,
      //     id: person.id
      //   }
      // }
      // return new Promise((res, rej) => {
      //   dispatch('jv/patch', [mdl, {url: `/person/${person.id}/availability`}]).then(
      //     (data) => {
      //       res(data)
      //   }).catch(rej)
      // })
    },
    [GET_PERSON_EXCLUSIONS] ({commit, dispatch, state}) {
      // Return a promise with the exclusions
      return new Promise((res, rej) => {
        // if(state.user.id) {
        //   dispatch('jv/get',`/person/${state.user.id}/availability`).then((availabilities) => {
        //     res(availabilities);
        //   })
        // } else {
        //   res({});
        // }
      })
    }
  },
  getters: {
  }
}
