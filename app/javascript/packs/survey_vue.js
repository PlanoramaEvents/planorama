import Vue from 'vue';
import Vuex from 'vuex';

import SurveyTable from '../surveys/survey_table.vue'
import { store as surveyStore } from '../surveys/survey.store'

Vue.use(Vuex);

const store = new Vuex.Store(surveyStore);

// TODO: can I abstract this ?
document.addEventListener('DOMContentLoaded', () => {

  const app = new Vue(
    {
      components: {
        SurveyTable
      },
      store,
    }
  )
  app.$mount('#survey-app')
})
