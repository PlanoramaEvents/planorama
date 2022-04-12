import { NEW } from './model.store';

export const GET_EMAIL_ADDRESSES = 'GET EMAIL ADDRESSES';

export const NEW_EMAIL_ADDRESS = 'NEW EMAIL ADDRESS';

export const emailAddressModel = 'email_address';

import { personModel } from '@/store/person.store'

export const emailAddressEndpoints = {
  [emailAddressModel]: 'email_address'
}

export const emailAddressStore = {
  actions: {
    [NEW_EMAIL_ADDRESS] ({dispatch}, attributes) {
      return dispatch(NEW, {model: emailAddressModel, selected: false, ...attributes})
    },
    [GET_EMAIL_ADDRESSES] ({commit, dispatch, state}) {
      return new Promise((res, rej) => {
        if(state.user.id) {
          dispatch('jv/get',`/person/${state.user.id}/email_addresses`).then((addrs) => {
            res(addrs);
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
