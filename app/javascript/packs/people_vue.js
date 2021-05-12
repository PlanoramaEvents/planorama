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
    label: 'ID',
    // width: '350',
    // // sticky: true,
    // numeric: true
    // // searchable: true,
  },
  {
    key: '$.published_name',
    label: 'Published Name',
    stickyColumn: true,
    // // sticky: true,
    // width: '700',
    // searchable: true,
    sortable: true
  },
  {
    key: '$.published_last_name',
    label: 'Published Last Name',
    // width: '400',
    // searchable: true,
    sortable: true
  },
  {
    key: '$.first_name',
    label: 'First Name',
    // width: '400',
    // searchable: true,
    sortable: true
  },
  {
    key: '$.last_name',
    label: 'Last Name',
    // width: '400',
    // searchable: true,
    sortable: true
  },
  {
    key: '$.pronouns',
    label: 'Pronouns',
    // width: '400',
    // searchable: false,
    sortable: false
  },
  {
    key: '$.registered',
    label: 'Registered',
    // width: '250',
    // searchable: true,
    sortable: true
  },
  {
    key: '$.registration_type',
    label: 'Registration Type',
    // width: '250',
    // searchable: true,
    sortable: true
  },
  {
    key: '$.registration_number',
    label: 'Registration Number',
    // width: '250',
    // searchable: true,
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
          collection: people,
          columns: people_columns,
          sortOrder: 'asc',
          sortField: 'published_last_name',
          selected: null,
          hasSelected: has_selected,
          // primary-key
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
          console.debug("SET SELECTED", v)
          this.selected = v
          this.editable = false
          this.hasSelected = this.selected != null
          this.$refs.sidebarComponent.setSelected(this.hasSelected);
        }
      }
    }
  )
  console.log("mounting people app")
  app.$mount('#people-app')
})
