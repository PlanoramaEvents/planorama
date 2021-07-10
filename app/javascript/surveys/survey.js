import {PlanoModel, PlanoCollection} from '../model.js';
import {
    required,
    string,
} from 'vue-mc/validation'

export class Survey extends PlanoModel {
  schema() {
    let s = super.schema()
    delete s.survey_pages;
    delete s.id;
    return s
  }
  defaults() {
    return {
      id: null,
      name: '',
      welcome: null,
      thank_you: null,
      submit_string: '',
      use_captcha: false,
      public: false,
      mandatory_star: true,
      numbered_questions: false,
      branded: true,
      allow_submission_edits: true,
      //transition_accept_status: false,
      //transition_decline_status: false,
      declined_msg: '',
      anonymous: false,
      survey_pages: [{
        id: null,
        title: null,
        survey_questions: [{
          id: null,
          question: '',
          question_type: 'textfield',
          mandatory: false,
          survey_answers: [{
            other: false,
            id: null,
            answer: '',
          }]
        }]
      }]
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

  getSaveData() {
    const data = super.getSaveData()
    if(data.survey_pages) {
      data.survey_pages_attributes = data.survey_pages.map((page, i) => {
        if (page.survey_questions) {
          page.survey_questions_attributes = page.survey_questions.map((q, j) => {
            if(q.survey_answers) {
              q.survey_answers_attributes = q.survey_answers.map((a, k) => {
                a.sort_order = k
                return a
              })
            }
            q.sort_order = j;
            return q
          })
        }
        page.sort_order = i
        return page
      })
    }
    return data;
  }
};

export class Surveys extends PlanoCollection {
  options() {
    return {
      model: Survey,
    }
  }

  defaults() {
    return Object.assign({}, super.defaults(), {
      sortField: 'updated_at',
      sortOrder: 'asc',
      filter: '',
      perPage: 15,
    })
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
    key: 'description',
    label: 'Description',
    sortable: true,
  },
  {
    key: '$.public',
    label: 'Status',
    formatter: (p) => p ? 'Published' : 'Closed',
    sortable: true,
  },
  {
    key: 'publishedOn',
    label: 'Published On',
    sortable: true,
  },
  {
    key: '$.updated_at',
    label: 'Last Modified On',
    sortable: true,
    formatter: (d) => new Date(d).toLocaleDateString()
  },
  {
    key: 'updated_by',
    label: 'Last Modified By',
    sortable: true
  },
  'preview',
  'surveyLink',
  // welcome
  // thank_you
  // submit_string
  // use_captcha
  // public
  // transition_acceptance_status
  // transition_decline_status
  // declined_msg
  // anonymous
];
