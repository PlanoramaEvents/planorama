// TODO move column definition out of here and then obsolete it
import {PlanoModel, PlanoCollection} from '../model.js';
import { SurveySubmissions } from './survey_response';
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
      description: null,
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
      survey_responses: [],
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

  duplicate() {
    return new Survey({
      name: `Copy of ${this.name}`,
      description: this.description,
      welcome: this.welcome,
      thank_you: this.thank_you,
      submit_string: this.submit_string,
      use_captcha: this.use_captcha,
      public: false,
      mandatory_star: this.mandatory_star,
      numbered_questions: this.numbered_questions,
      branded: this.branded,
      allow_submission_edits: true,
      anonymous: this.anonymous,
      survey_pages: this.survey_pages.map(p => ({
        title: p.title,
        survey_questions: p.survey_questions.map(q => ({
          question: q.question,
          question_type: q.question_type,
          mandatory: q.mandatory,
          survey_answers: q.survey_answers.map(a => ({
            other: a.other,
            answer: a.answer,
          }))
        }))
      }))
    })

  }

  surveyQuestions() {
    return this.survey_pages.reduce((p,c) => [...p, ...c.survey_questions], [])
  }

  extractQuestions(question_ids) {
    let old_questions = this.surveyQuestions().filter(q => question_ids.includes(q.id))
    let extracted_questions = old_questions.map(q => ({
      question: q.question,
      question_type: q.question_type,
      mandatory: q.mandatory,
      survey_answers: q.survey_answers.map(a => ({
        other: a.other,
        answer: a.answer,
      }))
    }))
    for (let question of old_questions) {
      question._destroy = true;
    }
    return extracted_questions
  }

  moveQuestions(question_ids, new_page_id) {
    let new_page = this.survey_pages.find(p => p.id == new_page_id)
    if(!new_page.survey_questions) {
      new_page.survey_questions = []
    }
    new_page.survey_questions.push(...this.extractQuestions(question_ids));
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
      perPage: 10,
      sortField: 'updated_at',
      sortOrder: 'desc'
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
    key: 'name',
    sortKey: 'surveys.name',
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
    key: 'public',
    label: 'Status',
    formatter: (p) => p ? 'Published' : 'Closed',
    sortable: true,
  },
  {
    key: 'published_on',
    label: 'Published On',
    sortable: true,
  },
  {
    key: 'updated_at',
    label: 'Last Modified On',
    sortable: true,
    formatter: (d) => new Date(d).toLocaleDateString()
  },
  {
    key: 'updated_by.name',
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
