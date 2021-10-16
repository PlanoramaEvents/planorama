import Vue from 'vue'
import Vuex from 'vuex'
import { jsonapiModule, utils } from 'jsonapi-vuex'
import { http } from '../http';

export const SELECT = 'SELECT';
export const UNSELECT = 'UNSELECT';

export const SELECTED = 'SELECTED';
export const FETCH_SELECTED = 'FETCH SELECTED';
export const FETCH = 'FETCH';
export const NEW = 'NEW';

// people add-ons
import { personStore, personEndpoints } from './person.store';

// session add-ons
import { sessionStore } from './session.store';

const endpoints = {
  ...personEndpoints,
  survey: 'survey'
}

// NOTE: this is really the store
Vue.use(Vuex)
export const store = new Vuex.Store({
  modules: {
    jv: jsonapiModule(http, {preserveJson: true, clearOnUpdate: true})
  },
  state: {
    selected: {
      ...personStore.selected,
      survey: undefined,
      page: undefined,
      question: undefined,
      submission: undefined,
    },
    ...sessionStore.state,
  },
  getters: {
    [SELECTED] (state, getters) {
      return ({model}) => {
        if (!state.selected[model]) return undefined;
        // TODO: this needs to be checked for grid reactivity ????
        return utils.deepCopy(getters['jv/get']({_jv: {id: state.selected[model], type: model}}))
      }
    },
    ...personStore.getters,
  },
  mutations: {
    [SELECT] (state, {model, itemOrId}) {
      let id;
      // NOTE: the try/catch was broken. Tested with passing in an id
      if (typeof itemOrId.id !== 'undefined') {
        id = itemOrId.id;
      } else {
        id = itemOrId;
      }
      // try {
      //   // console.debug("***** SELECT we have item????", itemOrId.id)
      //   id = itemOrId.id;
      // } catch {
      //   // console.debug("***** SELECT we have id????")
      //   id = itemOrId;
      // }
      state.selected[model] = id;
    },
    [UNSELECT] (state, {model}) {
      state.selected[model] = undefined;
    },
    ...sessionStore.mutations,
  },
  actions: {
    [NEW] ({commit, dispatch}, {model, selected = false, ...attrs}) {
      let newModel = {
        ...attrs,
        _jv: {
          type: model
        }
      }
      return new Promise((res, rej) => {
        dispatch('jv/post', newModel).then((savedModel) => {
          if (selected) {
            commit(SELECT, {model, itemOrId: savedModel});
          }
          res(savedModel);
        }).catch(rej);
      });
    },
    [FETCH] ({dispatch}, {model, params}) {
      return dispatch('jv/get', [endpoints[model], {params}])
    },
    [FETCH_SELECTED] ({state, dispatch}, {model}) {
      if (!state.selected[model]) {
        return Promise.reject(`No ${model} selected`)
      }
      return dispatch('jv/get', `${endpoints[model]}/${state.selected[model]}`)
    },
    ...sessionStore.actions,
  }
})
