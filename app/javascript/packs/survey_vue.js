import Vue from 'vue';
import Vuex from 'vuex';

import SurveyTable from '../surveys/survey_table.vue'
import SurveySidebar from '../surveys/survey_sidebar.vue'
import { store as surveyStore } from '../surveys/survey.store'

Vue.use(Vuex);

const store = surveyStore.initialize(Vuex)
const app = new Vue(
  {
    components: {
      SurveyTable,
      SurveySidebar,
    },
    store,
  }
)

document.addEventListener('DOMContentLoaded', () => {
  app.$mount('#survey-app')
})
