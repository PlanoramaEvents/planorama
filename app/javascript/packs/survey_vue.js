import Vue from 'vue';
import Vuex from 'vuex';
import VueRouter from 'vue-router';

import SurveyList from '../surveys/survey-list.vue';
import EditSurvey from '../surveys/edit-survey.vue';
import TakeSurvey from '../surveys/take-survey.vue';
import SurveyPage from '../surveys/survey-page.vue';
import SurveyThankYou from '../surveys/survey-thank-you.vue';
import { store as surveyStore } from '../surveys/survey.store'
import {BootstrapVue, BootstrapVueIcons} from 'bootstrap-vue';
import { CustomIconsPlugin } from '../icons';

Vue.use(Vuex);
Vue.use(VueRouter);
Vue.use(BootstrapVue);
Vue.use(BootstrapVueIcons);
Vue.use(CustomIconsPlugin);

const routes = [
  { path: '/edit/:id/:responses', component: EditSurvey, props: true},
  { path: '/edit/:id', component: EditSurvey, props: true },
  { path: '/:survey_id/page/:id/:preview', component: SurveyPage, props: true},
  { path: '/:survey_id/page/:id', component: SurveyPage, props: true},
  { path: '/:id/thankyou', component: SurveyThankYou, props: true},
  { path: '/:id/:preview', component: TakeSurvey, props: true },
  { path: '/:id', component: TakeSurvey, props: true},
  { path: '/', component: SurveyList },
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
