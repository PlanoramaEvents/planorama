import { SELECTED, NEW, SAVE, UNSELECT} from './model.store';
import { getOrderedRelationships } from '../utils/jsonapi_utils';

export const NEW_SURVEY = 'NEW SURVEY';
export const NEW_PAGE = 'NEW PAGE';
export const NEW_QUESTION = 'NEW QUESTION';
export const NEW_SUBMISSION = 'NEW SUBMISSION';
export const SAVE_SUBMISSION = 'SAVE SUBMISSION';
// TODO unused GET_NESTED SURVEY??
export const GET_NESTED_SURVEY = 'GET NESTED SURVEY';
export const CLEAR_SURVEY_SUBMISSIONS = 'CLEAR SURVEY SUBMISSIONS';
export const DUPLICATE_SURVEY = 'DUPLICATE SURVEY';
export const DUPLICATE_QUESTION = 'DUPLICATE QUESTION';

export const surveyModel = 'survey';
export const pageModel = 'page';
export const questionModel = 'question';
export const answerModel = 'answer';
export const submissionModel = 'submission';
export const responseModel = 'response';

export const surveyEndpoints = {
  [surveyModel]: 'survey',
  [pageModel]: 'page',
  [questionModel]: 'question',
  [answerModel]: 'answer',
  [submissionModel]: 'submission',
  [responseModel]: 'response'
}

export const surveyStore = {
  selected: {
    [surveyModel]: undefined,
    [pageModel]: undefined,
    [questionModel]: undefined,
    [submissionModel]: undefined,
  },
  getters: {
    // todo these don't work remove them
    selectedPage(state, getters) {
      return getters[SELECTED](pageModel);
    },
    selectedQuestion(state, getters) {
      return getters[SELECTED](questionModel);
    },
    selectedSubmission(state, getters) {
      return getters[SELECTED](submissionModel);
    },
  },
  actions: {
    [NEW_SURVEY] ({dispatch}) {
      let newSurvey = {
        name: 'New Survey',
        pages_attributes: [{
          title: 'New Survey',
          questions_attributes: [{
            question: 'New Question',
            question_type: "textfield",
            survey_answers_attributes: [{
              answer: 'Option 1'
            }]
          }]
        }]
      }
      return dispatch(NEW, {model: surveyModel, selected: true, newSurvey})
    },
    [NEW_PAGE] ({dispatch}, {surveyId, questionIds = []}) {
      // TODO sort order?
      let newPage = {
        title: 'New Page',
        relationships: {
          survey: {
            data: [{
              type: surveyModel,
              id: surveyId
            }]
          },
          question: {
            data: questionIds.map(id => ({type: questionModel, id}))
          }
        }
      }
      return dispatch(NEW, {model: pageModel, selected: true, ...newPage})
    },
    [NEW_QUESTION] ({dispatch}, {surveyId, pageId, questionType = "textfield"}) {
      // TODO sort order?
      let newQuestion = {
        question: 'New Question',
        question_type: questionType,
        survey_answers_attributes: [{
          answer: 'Option 1'
        }],
        relationships: {
          survey: {
            data: [{
              type: surveyModel,
              id: surveyId
            }]
          },
          page: {
            data: [{
              type: pageModel,
              id: pageId
            }]
          }
        }
      };
      return dispatch(NEW, {model: questionModel, selected: true, ...newQuestion});
    },
    [NEW_SUBMISSION] ({dispatch}, {surveyId}) {
      let newSubmission = {
        relationships: {
          survey: {
            data: [{
              type: surveyModel,
              id: surveyId
            }]
          }
        }
      };
      return dispatch(NEW, {model: submissionModel, selected: true, ...newSubmission});
    },
    [SAVE_SUBMISSION] ({dispatch, getters, commit}, {item}) {
      if (!item) {
        item = getters.selectedSubmission;
      }
      return new Promise((res, rej) => {
        dispatch(SAVE, {model: submissionModel, item}).then((result) => {
          commit(UNSELECT, {model: submissionModel});
          res(result);
        }).catch(rej);
      });
    },
    [CLEAR_SURVEY_SUBMISSIONS] ({dispatch}, {item}) {
      return new Promise((res, rej) => {
        res("This has not been implemented yet")
      })
    },
    [DUPLICATE_SURVEY] ({dispatch}, {item}) {
      let newSurvey = {
        name: `Copy of ${item.name}`,
        description: item.description,
        welcome: item.welcome,
        thank_you: item.thank_you,
        submit_string: item.submit_string,
        use_captcha: item.use_captcha,
        public: false,
        mandatory_star: item.mandatory_star,
        numbered_questions: item.numbered_questions,
        branded: item.branded,
        allow_submission_edits: true,
        anonymous: item.anonymous,
        // TODO fix survey_pages
        pages_attributes: item.pages.map(p => ({
          title: p.title,
          // TODO fix questions
          questions_attributes: p.questions.map(q => ({
            question: q.question,
            question_type: q.question_type,
            mandatory: q.mandatory,
            // TODO fix survey_answers
            survey_answers_attributes: q.survey_answers.map(a => ({
              other: a.other,
              answer: a.answer,
            })),
          })),
        })),
      }
      return dispatch(NEW, {model: surveyModel, selected: true, ...newSurvey})
    },
    [DUPLICATE_QUESTION] ({dispatch}, {item, insertAt}) {
      let newQuestion = {
        question: item.question,
        question_type: item.question_type,
        mandatory: item.mandatory,
        text_size: item.text_size,
        horizontal: item.horizontal,
        private: item.private,
        regex: item.regex,
        survey_answers_attributes: getOrderedRelationships('survey_answers', item).map(a => ({
          answer: a.answer,
          default: a.default,
          other: a.other,
        }))
      }
      if (insertAt) {
        newQuestion.sort_order_position = insertAt
      }
      let relationships= {
        survey_page: {
          id: item.page_id,
          type: pageModel
        }
      }
      return dispatch(NEW, {model: questionModel, selected: true, relationships, ...newQuestion})
    }
  }
}
