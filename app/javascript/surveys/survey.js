import PlanoModel from '../model.js';
import {Collection} from 'vue-mc';
import {
    required,
    string,
} from 'vue-mc/validation'

export class Survey extends PlanoModel {
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
  mutations() {
    return {
      public: (p) => p ? 'Published' : 'Closed',
      alias: () => "We don't track this yet.",
      id: () => 'TODO PREVIEW LINK',
      anonymous: (a) => a ? 'link here' : ''
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

export class Surveys extends Collection {
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
      // TODO UNDO ME
      //perPage: 30,
      perPage:5,
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

export const survey_columns = [
  {
    key: '$.name',
    label: 'Name',
    stickyColumn: true,
    sortable: true
  },
  {
    key: '$.welcome',
    label: 'Description',
    sortable: true
  },
  {
    key: '$.public',
    label: 'Published',
    sortable: true
  },
  {
    key: '$.alias',
    label: 'Published On',
    sortable: true
  },
  {
    key: '$.updated_at',
    label: 'Last Modified On',
    sortable: true
  },
  {
    key: '$.id',
    label: 'Preview',
  },
  {
    key: '$.anonymous',
    label: 'Link'
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

