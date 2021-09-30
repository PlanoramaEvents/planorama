import Vue from 'vue'
import Vuex from 'vuex'
import { jsonapiModule } from 'jsonapi-vuex'
import { http } from '../http';

export const SELECT = 'SELECT';
export const UNSELECT = 'UNSELECT';
export const SAVE = 'SAVE'

// NOTE: this is really the store
Vue.use(Vuex)
export const modelStore = new Vuex.Store({
  // Do we need selected and collection???
  state: {
    selected: undefined
  },
  modules: {
    jv: jsonapiModule(http, {preserveJson: true, clearOnUpdate: true})
  },
  mutations: {
    [SELECT] (state, item) {
      console.log('**** SELECT', item)
      state.selected = item;
    },
    [UNSELECT] (state) {
      state.selected = undefined;
    }
  }

})
