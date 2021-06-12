import Vue from 'vue'
import Vuex from 'vuex';

import PeopleTable from '../people/people_table.vue';
import PeopleSidebar from '../people/people_sidebar.vue';
import { store as peopleStore } from '../people/people.store';

Vue.use(Vuex);
const store = peopleStore.initialize(Vuex);
const app = new Vue({
  components: {
    PeopleTable,
    PeopleSidebar,
  },
  store,
})

document.addEventListener('DOMContentLoaded', () => {
  app.$mount('#people-app')
})
