import Vue from 'vue';
import Vuex from 'vuex';

import SurveyTable from '../surveys/survey_table.vue'
import SurveySidebar from '../surveys/survey_sidebar.vue'
import { store as surveyStore } from '../surveys/survey.store'

Vue.use(Vuex);

const store = new Vuex.Store(surveyStore);

document.addEventListener('DOMContentLoaded', () => {

  const app = new Vue(
    {
      components: {
        SurveyTable,
        SurveySidebar
      },
      store,
    }
  )
  app.$mount('#survey-app')
})
