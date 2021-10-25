import Vue from 'vue'
import Vuex from 'vuex'
import { jsonapiModule, utils } from 'jsonapi-vuex'
import { http } from '../http';

export const SELECT = 'SELECT';
export const UNSELECT = 'UNSELECT';

export const SELECTED = 'SELECTED';
export const FETCH_SELECTED = 'FETCH SELECTED';
export const FETCH_BY_ID = 'FETCH BY ID'
export const FETCH = 'FETCH';
export const NEW = 'NEW';
export const SAVE = 'SAVE';
export const DELETE = 'DELETE';

// people add-ons
import { personStore, personEndpoints } from './person.store';

// session add-ons
import { sessionStore } from './session.store';

// survey add-ons
import { surveyStore, surveyEndpoints } from './survey.store';

const getId = (itemOrId) => {
  try {
    return itemOrId.id || id;
  } catch {
    return itemOrId;
  }
}

const endpoints = {
  ...personEndpoints,
  ...surveyEndpoints,
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
      ...surveyStore.selected,
    },
    ...sessionStore.state,
  },
  getters: {
    [SELECTED] (state, getters) {
      return ({model}) => {
        if (!state.selected[model]) return undefined;
        return utils.deepCopy(getters['jv/get']({_jv: {id: state.selected[model], type: model}}))
      }
    },
    ...personStore.getters,
    ...surveyStore.getters,
    ...sessionStore.getters,
  },
  mutations: {
    [SELECT] (state, {model, itemOrId}) {
      state.selected[model] = getId(itemOrId);
    },
    [UNSELECT] (state, {model}) {
      state.selected[model] = undefined;
    },
    ...sessionStore.mutations,
  },
  actions: {
    [NEW] ({commit, dispatch}, {model, selected = false, relationships = {}, ...attrs}) {
      let newModel = {
        ...attrs,
        _jv: {
          type: model,
          relationships
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
    [SAVE] ({commit, dispatch}, {model, selected = true, item, params}) {
      if(item._jv) {
        if(!item._jv.type) {
          type = model
        }
      }
      else {
        item._jv = { type: model }
      }
      return new Promise((res, rej) => {
        dispatch('jv/patch', [endpoints[model], {params}]).then((savedModel) => {
          // to get around the fact that the getter returns a copy,
          // re-select the saved model so that the getter updates.
          if(selected) {
            commit(SELECT, {model, itemOrId: savedModel});
          }
          res(savedModel);
        }).catch(rej)
      });
    },
    [DELETE] ({dispatch}, {model, itemOrId}) {
      return dispatch('jv/delete', `${endpoints[model]}/${getId(itemOrId)}`)
    },
    [FETCH] ({dispatch}, {model, params}) {
      return dispatch('jv/get', [endpoints[model], {params}])
    },
    [FETCH_SELECTED] ({state, dispatch}, {model}) {
      if (!state.selected[model]) {
        return Promise.reject(`No ${model} selected`)
      }
      return dispatch(FETCH_BY_ID, {model, id: state.selected[model]})
    },
    [FETCH_BY_ID] ({dispatch}, {model, id}) {
      // TODO do we ever need this? or is model always selected
      return dispatch('jv/get', `${endpoints[model]}/${id}`)
    },
    ...sessionStore.actions,
    ...surveyStore.actions,
  }
})
