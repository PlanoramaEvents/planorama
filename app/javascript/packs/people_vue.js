import Vue from 'vue/dist/vue.esm'
import Buefy from 'buefy'
import CKEditor from 'ckeditor4-vue'
import '../stylesheets/style.scss'
import TableComponent from '../table.vue'
import SidebarComponent from '../sidebar.vue'

import PlanoModel from '../model.js'

Vue.use(Buefy)
Vue.use( CKEditor );

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
    field: 'id',
    label: 'ID',
    width: '350',
    // sticky: true,
    numeric: true
    // searchable: true,
  },
  {
    field: '$.published_name',
    label: 'Published Name',
    // sticky: true,
    width: '700',
    searchable: true,
    sortable: true
  },
  {
    field: '$.published_last_name',
    label: 'Published Last Name',
    width: '400',
    searchable: true,
    sortable: true
  },
  {
    field: '$.first_name',
    label: 'First Name',
    width: '400',
    searchable: true,
    sortable: true
  },
  {
    field: '$.last_name',
    label: 'Last Name',
    width: '400',
    searchable: true,
    sortable: true
  },
  {
    field: '$.pronouns',
    label: 'Pronouns',
    width: '400',
    searchable: false,
    sortable: false
  },
  {
    field: '$.registered',
    label: 'Registered',
    width: '250',
    searchable: true,
    sortable: true
  },
  {
    field: '$.registration_type',
    label: 'Registration Type',
    width: '250',
    searchable: true,
    sortable: true
  },
  {
    field: '$.registration_number',
    label: 'Registration Number',
    width: '250',
    searchable: true,
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
  let has_selected = false

  const app = new Vue(
    {
      components: {
        TableComponent,
        SidebarComponent
      },
      data() {
        return {
          sortOrder: 'asc',
          sortField: 'published_last_name',
          columns: people_columns,
          collection: people,
          selected: null,
          hasSelected: has_selected,
          editable : false,
          editorConfig: {
            readOnly: true
          }
        }
      },
      methods: {
        onSave() {
          let new_instance = typeof this.selected.id === 'undefined'
          this.selected.save().then(
            (arg) => {
              if (new_instance) {
                this.selected = null
                this.editable = false
                this.hasSelected = this.selected != null
                this.$refs.sidebarComponent.setSelected(this.hasSelected);
                this.$refs.tableComponent.loadAsyncData();
              }
            }
          )
        },
        onReset() {
          if (this.selected) this.selected.fetch()
        },
        onCreate() {
          // Create a new model and make that the selected on on the sidebar
          this.selected = new Person();
          this.hasSelected = this.selected != null
          this.editable = true
          this.$refs.sidebarComponent.setSelected(this.hasSelected);
        },
        setSelected(v) {
          this.selected = v
          this.editable = false
          this.hasSelected = this.selected != null
          this.$refs.sidebarComponent.setSelected(this.hasSelected);
        }
      }
    }
  )
  app.$mount('#people-app')
})
