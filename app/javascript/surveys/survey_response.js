import {PlanoModel} from "../model";

export class SurveySubmission extends PlanoModel {
  defaults() {
    return {
      id: null,
      created_at: new Date(),
      updated_at: new Date(),
      lock_version: 0,
      survey_id: 0,
      person_id: null,
      survey_responses: []
    }
  }
  routes() {
    return {
      fetch: '/surveys/{survey_id}/submissions/{id}',
      create: '/surveys/{survey_id}/submissions',
      save: '/surveys/{survey_id}/submissions/{id}',
      update: '/surveys/{survey_id}/submissions/{id}',
      delete: '/surveys/{survey_id}/submissions/{id}'
    }
  }
  getSaveData() {
    const data = super.getSaveData()
    if(data.survey_responses) {
      data.survey_responses_attributes = data.survey_responses
    }
    return data;
  }
}
