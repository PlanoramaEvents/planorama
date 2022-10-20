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
    [GET_PERSON_EXCLUSIONS] ({dispatch}, {person}) {
      return new Promise((res, rej) => {
        if(person.id) {
          dispatch('jv/get',`/person/${person.id}/person_exclusion`).then((exclusions) => {
            res(exclusions);
          }).catch(rej)
        } else {
          res({});
        }
      })
    }
  },
  getters: {
    exclusionsForPerson(store, getters) {
      return (person) => Object.values(getters['jv/get'](
          {_jv: {type: personExclusionModel}}, 
          `$[?(@.person_id=='${person.id}')]`
        ));
    }
  }
}
