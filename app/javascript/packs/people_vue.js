import Vue from 'vue'
// import CKEditor from 'ckeditor4-vue'

import PlanoModel from '../model.js'
import TableComponent from '../table.vue'
import SidebarComponent from '../sidebar.vue'
// Vue.use( CKEditor );
import {Collection} from 'vue-mc'
import {
    boolean,
    equal,
    integer,
    min,
    required,
    string,
} from 'vue-mc/validation'

class Person extends PlanoModel {
  defaults() {
    return {
      // id: null,
      first_name: null,
      last_name: ''
    }
  }
  validation() {
    return {
      last_name: string.and(required)
    }
  }
  routes() {
    // TODO: do we need a custom route for update instaed of save???
    // see http://vuemc.io/#model-request-custom
    return {
      fetch: '/people/{id}',
      create:  '/people',
      save:  '/people/{id}',
      update: '/people/{id}',
      delete: '/people/{id}'
    }
  }
};

class People extends Collection {
  options() {
    return {
      model: Person,
    }
  }

  defaults() {
    return {
      sortField: 'published_last_name',
      sortOrder: 'asc',
      filter: '',
      perPage: 30,
      page: 1,
      total: 0
    }
  }

  routes() {
    return {
      // fetch: '/people',
      fetch: '/people?perPage={perPage}&sortField={sortField}&sortOrder={sortOrder}&filter={filter}',
    }
  }
};

// task.$.name or task.saved('name') to reflect what is in the backend ...
const people_columns = [
  {
    key: 'id',
    label: 'ID'
  },
  {
    key: '$.published_name',
    label: 'Published Name',
    stickyColumn: true,
    sortable: true
  },
  {
    key: '$.published_last_name',
    label: 'Published Last Name',
    sortable: true
  },
  {
    key: '$.first_name',
    label: 'First Name',
    sortable: true
  },
  {
    key: '$.last_name',
    label: 'Last Name',
    sortable: true
  },
  {
    key: '$.pronouns',
    label: 'Pronouns',
    sortable: false
  },
  {
    key: '$.registered',
    label: 'Registered',
    sortable: true
  },
  {
    key: '$.registration_type',
    label: 'Registration Type',
    sortable: true
  },
  {
    key: '$.registration_number',
    label: 'Registration Number',
    sortable: true
  }
  // {
  //   field: '$.bio',
  //   label: 'Bio',
  //   width: '250',
  //   searchable: false,
  //   sortable: false
  // }
];

document.addEventListener('DOMContentLoaded', () => {
  let people = new People()

  const app = new Vue(
    {
      components: {
        TableComponent,
        SidebarComponent
      },
      data() {
        return {
          modelType: Person,
          collection: people,
          columns: people_columns,
          sortOrder: 'asc',
          sortField: 'published_last_name'
          // selected: null
        }
      }
    }
  )
  app.$mount('#people-app')
})
