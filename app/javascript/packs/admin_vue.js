import Vue from 'vue';
import Vuex from 'vuex';
import {BootstrapVue, BootstrapVueIcons} from 'bootstrap-vue';

import AdminComponent from '../administration/admin_component.vue';
import { store as settingsStore } from '../administration/configurations.store';

Vue.use(Vuex);
Vue.use(BootstrapVue);
Vue.use(BootstrapVueIcons);
const store = settingsStore.initialize(Vuex);

const app = new Vue({
  components: {
    AdminComponent,
  },
  store
})

document.addEventListener('DOMContentLoaded', () => {
  app.$mount('#admin-app')
})
