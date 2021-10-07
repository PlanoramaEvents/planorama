import Vue from 'vue'
import Vuex from 'vuex'
import { jsonapiModule } from 'jsonapi-vuex'
import { http } from '../http';

export const SELECT = 'SELECT';
export const UNSELECT = 'UNSELECT';
export const SAVE = 'SAVE'

export const SET_SESSION_USER = "SET SESSION USER";
export const GET_SESSION_USER = "GET SESSION USER";

// NOTE: this is really the store
Vue.use(Vuex)
export const modelStore = new Vuex.Store({
  // Do we need selected and collection???
  state: {
    selected: undefined,
    user: {}
  },
  modules: {
    jv: jsonapiModule(http, {preserveJson: true, clearOnUpdate: true})
  },
  mutations: {
    // TODO: change the select to be a collection of objs indexed by type
    [SELECT] (state, item) {
      console.log('**** SELECT', item)
      state.selected = item;
    },
    [UNSELECT] (state) {
      state.selected = undefined;
    },
    [SET_SESSION_USER] (state, user) {
      state.user = user
    }
  },
  actions: {
    [GET_SESSION_USER] ({commit, dispatch, state}) {
      // only fetch session if we don't have one
      if(!state.user.id) {
        // console.debug('******* get the session user')
        dispatch('jv/get','/people/me').then((user) => {
          // console.debug('******* session user', user)
          commit(SET_SESSION_USER, user)
        }).catch((error) => {
          // console.debug('******* error', error)
          // If we can not get the session then set no no user
          commit(SET_SESSION_USER, {})
        })
      }
    }
  }
})
