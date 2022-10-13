import { NEW } from './model.store';

export const NEW_AVAILABILITY = 'NEW AVAILABILITY';
export const GET_AVAILABILITY = 'GET AVAILABILITY';
export const UPDATE_AVAILABILITY = 'UPDATE AVAILABILITY';

export const availabilityModel = 'availability';

import { personModel } from '@/store/person.store'
import { DateTime, Duration } from 'luxon';

export const availabilityEndpoints = {
  [availabilityModel]: 'availability'
}

export const availabilityStore = {
  actions: {
    // Need to set availabilities for a person
    [NEW_AVAILABILITY] ({dispatch}, attributes) {
      return dispatch(NEW, {model: availabilityModel, selected: false, ...attributes})
    },
    // patch person/availabilities
    [UPDATE_AVAILABILITY] ({dispatch}, {person, params}) {
      const mdl = {
        availabilities_attributes: params,
        _jv: {
          type: personModel,
          id: person.id
        }
      }
      return new Promise((res, rej) => {
        dispatch('jv/patch', [mdl, {url: `/person/${person.id}/availability`}]).then(
          (data) => {
            res(data)
        }).catch(rej)
      })
    },
    [GET_AVAILABILITY] ({dispatch}, {person}) {
      // Return a promise with the availabilities
      return new Promise((res, rej) => {
        if(person.id) {
          dispatch('jv/get',`/person/${person.id}/availability`).then((availabilities) => {
            res(availabilities);
          })
        } else {
          res({});
        }
      })
    }
  },
  selected: {
    [availabilityModel]: undefined
  },
  getters: {
    availabilitiesForPerson(store, getters) {
      return (person) => {
        const availabilities = Object.values(getters['jv/get'](
          {_jv: {type: availabilityModel}}, 
          `$[?(@.person_id=='${person.id}')]`
        ));
        return availabilities.map((a) => { return {start: DateTime.fromISO(a.start_time) , end: DateTime.fromISO(a.end_time)} })
      };
    }
  }
}
