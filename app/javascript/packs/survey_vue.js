import Vue from 'vue';
import Vuex from 'vuex';
import VueRouter from 'vue-router';

import SurveyList from '../surveys/survey-list.vue'
import EditSurvey from '../surveys/edit-survey.vue';
import { store as surveyStore } from '../surveys/survey.store'
import {BootstrapVue, BootstrapVueIcons} from 'bootstrap-vue';

Vue.use(Vuex);
Vue.use(VueRouter);
Vue.use(BootstrapVue);
Vue.use(BootstrapVueIcons);

const routes = [
  { path: '/', component: SurveyList },
  { path: '/edit/:id', component: EditSurvey, props: true }
]

const router = new VueRouter({ routes })

const store = surveyStore.initialize(Vuex)
const app = new Vue(
  {
    store,
    router,
  }
)

document.addEventListener('DOMContentLoaded', () => {
  app.$mount('#survey-app')
})
