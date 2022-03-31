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
      const mdl = {
        person_exclusions_attributes: params,
        _jv: {
          type: personModel,
          id: person.id
        }
      }
      return new Promise((res, rej) => {
        dispatch('jv/patch', [mdl, {url: `/person/${person.id}/person_exclusion`}]).then(
          (data) => {
            res(data)
        }).catch(rej)
      })
    },
    // Return a promise with the exclusions
    [GET_PERSON_EXCLUSIONS] ({commit, dispatch, state}) {
      return new Promise((res, rej) => {
        if(state.user.id) {
          dispatch('jv/get',`/person/${state.user.id}/person_exclusion`).then((exclusions) => {
            res(exclusions);
          })
        } else {
          res({});
        }
      })
    }
  },
  getters: {
  }
}
