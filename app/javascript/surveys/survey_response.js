import PlanoModel from "../model";

export class SurveyResponse extends PlanoModel {
  defaults() {
    return {
      id: 0,
      created_at: new Date(),
      updated_at: new Date(),
      lock_version: 0,
      survey_id: 0,
      survey_question_id: 0,
      person_id: 0,
      response: {},
      response_as_text: '',
    }
  }
  routes() {
    return {
      fetch: '/surveys/{survey_id}/responses/{id}',
      create: '/surveys/{survey_id}/responses',
      save: '/surveys/{survey_id}/responses/{id}',
      update: '/surveys/{survey_id}/responses/{id}',
      delete: '/surveys/{survey_id}/responses/{id}'
    }
  }
}
