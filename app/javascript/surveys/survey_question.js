import PlanoModel from '../model.js';
import { Collection } from 'vue-mc';

export class SurveyQuestion extends PlanoModel {
  defaults() {
    return {
      id: 0,
      survey_id: 0,
      title: '',
      question: '',
      tag_context: {
        id: 0,
        name: '',
        created_at: new Date(),
        updated_at: new Date(),
        publish: true
      },
      question_type: '',
      created_at: new Date(),
      updated_at: new Date(),
      mandatory: false,
      text_size: 12,
      sort_order: 0,
      answer_type: '',
      horizontal: false,
      private: false,
      regex: null,
      mapping: null,
    }
  }
  routes() {
    return {
      fetch: '/surveys/{survey_id}/questions/{id}',
      create: '/surveys/{survey_id}/questions',
      save: '/surveys/{survey_id}/questions/{id}',
      update: '/surveys/{survey_id}/questions/{id}',
      delete: '/surveys/{survey_id}/questions/{id}'
    }
  }
}

export class SurveyQuestions extends Collection {
  options() {
    return {
      model: SurveyQuestion,
    }
  }

  defaults() {
    return {
      sortField: 'sort_order',
      sortOrder: 'asc',
      survey_id: 0
    }
  }

  routes() {
    return {
      fetch: '/surveys/{survey_id}/questions?sortField={sortField}&sortOrder={sortOrder}',
    }
  }
}
