import Vue from 'vue'

import PlanoModel from '../model.js'
import TableWithSidebarComponent from '../table_with_sidebar.vue'
import {Collection} from 'vue-mc'
import {
    boolean,
    equal,
    integer,
    min,
    required,
    string,
} from 'vue-mc/validation'

class Survey extends PlanoModel {
  defaults() {
    return {
      id: null,
      last_name: ''
    }
  }
  validation() {
    return {
      name: string.and(required)
    }
  }
  routes() {
    return {
      fetch: '/surveys/{id}',
      create:  '/surveys',
      save:  '/surveys/{id}',
      update: '/surveys/{id}',
      delete: '/surveys/{id}'
    }
  }
};

class Surveys extends Collection {
  options() {
    return {
      model: Survey,
    }
  }

  defaults() {
    return {
      sortField: 'name',
      sortOrder: 'asc',
      filter: '',
      perPage: 30,
      page: 1,
      total: 0
    }
  }

  routes() {
    return {
      fetch: '/surveys?perPage={perPage}&sortField={sortField}&sortOrder={sortOrder}&filter={filter}',
    }
  }
};

const survey_columns = [
  {
    key: 'id',
    label: 'ID'
  },
  {
    key: '$.name',
    label: 'Name',
    stickyColumn: true,
    sortable: true
  },
  {
    key: '$.welcome',
    label: 'Welcome',
    sortable: true
  },
  {
    key: '$.alias',
    label: 'Alias',
    sortable: true
  }
  // welcome
  // thank_you
  // alias
  // submit_string
  // header_image
  // use_captcha
  // public
  // authenticate
  // transition_acceptance_status
  // transition_decline_status
  // declined_msg
  // anonymous
];

// TODO: can I abstract this ?
document.addEventListener('DOMContentLoaded', () => {
  let surveys = new Surveys()
  let has_selected = false

  const app = new Vue(
    {
      components: {
        TableWithSidebarComponent
      },
      data() {
        return {
          modelType: Survey,
          collection: surveys,
          columns: survey_columns,
          selectEvent: 'selectedSurvey',
          saveEvent: 'saveSurvey',
          sortField: 'welcome'
        }
      }
    }
  )
  app.$mount('#survey-app')
})
