import Vue from 'vue/dist/vue.esm'
import Buefy from 'buefy'
import '../stylesheets/style.scss'
import TableComponent from '../table.vue'

Vue.use(Buefy)

import {Model, Collection} from 'vue-mc'

class Person extends Model {
  defaults() {
    return {
      id: null,
      first_name: null,
      last_name: '',
    }
  }
  mutations() {
    return {
      id:   (id) => Number(id) || null,
      first_name: String,
      last_name: String,
    }
  }
  validation() {
    return {
      id: integer.and(min(1)).or(equal(null)),
      first_name: string,
      last_name: string.and(required),
    }
  }
  routes() {
    return {
      fetch: '/people/{id}',
      save:  '/people',
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
      perPage: 30,
      page: 1,
      total: 0
    }
  }

  routes() {
    return {
      // fetch: '/people',
      fetch: '/people?perPage={perPage}&sortField={sortField}&sortOrder={sortOrder}',
    }
  }
};

const people_columns = [
  {
    field: 'id',
    label: 'ID',
    width: '350',
    // sticky: true,
    numeric: true,
    searchable: true,
  },
  {
    field: 'published_name',
    label: 'Published Name',
    // sticky: true,
    width: '700',
    searchable: true,
    sortable: true
  },
  {
    field: 'published_last_name',
    label: 'Published Last Name',
    width: '400',
    searchable: true,
    sortable: true
  },
  {
    field: 'first_name',
    label: 'First Name',
    width: '400',
    searchable: true,
    sortable: true
  },
  {
    field: 'last_name',
    label: 'Last Name',
    width: '400',
    searchable: true,
    sortable: true
  },
  {
    field: 'pronouns',
    label: 'Pronouns',
    width: '400',
    searchable: false,
    sortable: false
  },
  {
    field: 'registered',
    label: 'Registered',
    width: '250',
    searchable: false,
    sortable: true
  },
  {
    field: 'registration_type',
    label: 'Registration Type',
    width: '250',
    searchable: false,
    sortable: true
  },
  {
    field: 'registration_number',
    label: 'Registration Number',
    width: '250',
    searchable: true,
    sortable: true
  }
];

document.addEventListener('DOMContentLoaded', () => {
  let people = new People()

  const app = new Vue(
    {
      components: { TableComponent },
      data() {
        return {
          sortOrder: 'asc',
          sortField: 'published_last_name',
          columns: people_columns,
          collection: people,
          selected: null,
          has_selected: false
        }
      },
      methods: {
        setSelected(v) {
          this.selected = v
          this.has_selected = this.selected != null
        }
      }
    }
  )
  app.$mount('#people-app')
})
