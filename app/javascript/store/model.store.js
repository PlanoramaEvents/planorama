import Vue from 'vue'
import Vuex from 'vuex'
import { jsonapiModule } from 'jsonapi-vuex'
import { http } from '../http';

// NOTE: this is really the store
Vue.use(Vuex)
export const modelStore = new Vuex.Store({
  modules: {
    jv: jsonapiModule(http, {preserveJson: true, clearOnUpdate: true})
  }
})
