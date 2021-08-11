import Vue from 'vue';
import Vuex from 'vuex';
import {BootstrapVue, BootstrapVueIcons} from 'bootstrap-vue';

import AdminComponent from '../administration/admin_component.vue';
import { store as adminStore } from '../administration/admin.store';
import { store as agreementStore } from '../administration/agreement.store'
import { store as settingsStore } from '../administration/configurations.store';
import { store as peopleStore } from '../administration/admin_people.store';

Vue.use(Vuex);
Vue.use(BootstrapVue);
Vue.use(BootstrapVueIcons);
const store = adminStore.initialize(Vuex);
settingsStore.registerAsModuleFor(store);
agreementStore.registerAsModuleFor(store);
peopleStore.registerAsModuleFor(store);

const app = new Vue({
  components: {
    AdminComponent,
  },
  store
})

document.addEventListener('DOMContentLoaded', () => {
  app.$mount('#admin-app')
})
