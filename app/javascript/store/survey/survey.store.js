import { NEW, FETCH_BY_ID, FETCH_SELECTED, PATCH_RELATED, SELECT, UNSELECT} from '../model.store';
// import { getOrderedRelationships } from '@/utils/jsonapi_utils';
import {
  NEW_SURVEY,
  NEW_PAGE,
  NEW_QUESTION,
  NEW_SUBMISSION,
  CLEAR_SURVEY_SUBMISSIONS,
  DUPLICATE_SURVEY,
  DUPLICATE_QUESTION,
  NEW_RESPONSE,
  SET_PREVIEW_MODE,
  SHOW_REDIR,
  REDIR_SHOWN
} from './survey.actions';
import {
  surveyModel,
  pageModel,
  questionModel,
  answerModel,
  submissionModel,
  responseModel,
} from './survey.model';

import { v4 as uuidv4 } from 'uuid';

import { utils } from 'jsonapi-vuex';
import { getId } from '@/utils';

import { personModel } from '../person.store';

export const GET_CACHED_INDEX = 'GET CACHED INDEX';

export const GET_CACHED_PAGES = 'GET CACHED PAGES';
export const GET_CACHED_QUESTIONS = 'GET CACHED QUESTIONS';
export const GET_CACHED_ANSWERS = 'GET CACHED ANSWERS';

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
  state: {
    previewMode: false,
    redirMessage: false,
    // A cache for the survey sorting
    indexCache: {
      pages: [], // ordered pages
      questions: {}, // ordered questions per page
      answers: {} // ordered answers per question
    }
  },
  getters: {
    [GET_CACHED_INDEX] (state, getters) {
      return state.indexCache
    },
    // Pages
    [GET_CACHED_PAGES] (state, getters) {
      return state.indexCache.pages
    },
    // Questions for a page
    [GET_CACHED_QUESTIONS]: (state) => (page_id) => {
      // console.debug('GET CACHED QUESTIONS')
      return state.indexCache.questions[page_id]
    },
    // Answers for a Question
    [GET_CACHED_ANSWERS]: (state) => (question_id) => {
      // console.debug('GET CACHED ANSWERS')
      return state.indexCache.answers[question_id]
    },
  },
  mutations: {
    [SET_PREVIEW_MODE](state, previewMode) {
      // console.debug("previewMode", previewMode)
      state.previewMode = previewMode
    },
    [SHOW_REDIR](state) {
      state.redirMessage = true
    },
    [REDIR_SHOWN](state) {
      state.redirMessage = false
    },
    [NEW_RESPONSE] (state, {relationships = {}, text = '', answers = [], socialmedia = {
        twitter: null, facebook: null, linkedin: null,
        twitch: null, youtube: null, instagram: null,
        tiktok: null, other: null, website: null,
        bsky: null, fediverse: null
    }}) {
      let id = uuidv4();
      let item = {
        id,
        response: {text, answers, socialmedia},
        _jv: {
          id,
          relationships,
          type: responseModel
        }
      };
      utils.updateRecords(state.jv, {[id]: item})
      // console.log(item);
      return item;
    }
  },
  plugins: [
    (store) => {
      store.subscribe((mutation, state) => {
        // Build a ordered cache of Survey elements upon select
        if ((mutation.type === SELECT) && (mutation.payload.model === 'survey')) {
          let instance = mutation.payload.itemOrId;
          if (typeof instance == 'string' || !instance) {
            return
          }

          state.indexCache.pages = Object.values(instance.pages).sort((a, b) => a.sort_order - b.sort_order)
          state.indexCache.questions = {}
          state.indexCache.answers = {}
          state.indexCache.pages.forEach(
            (page) => {
              state.indexCache.questions[page.id] = Object.values(page.questions).sort((a, b) => a.sort_order - b.sort_order)
              state.indexCache.questions[page.id].forEach(
                (question) => {
                  state.indexCache.answers[question.id] = Object.values(question.answers).sort((a, b) => a.sort_order - b.sort_order)
                }
              )
            }
          )
          // console.debug("****** PLUGIN for ", state.selected.survey, state.indexCache.pages);
          // console.debug("****** PLUGIN for ", state.selected.survey, state.indexCache.questions);
          // console.debug("****** PLUGIN for ", state.selected.survey, state.indexCache.answers);
          // console.debug("**** CACHE CREATED")
        }
        if ((mutation.type === SELECT) && (mutation.payload.model === 'question')) {
          // ensure that the page is also selected when a question is selected
          store.commit(SELECT, {model: pageModel, itemOrId: mutation.payload.itemOrId.page_id});
        }
        if (mutation.type === UNSELECT) {
          // clear the cache if we unselect the survey
          state.indexCache = {
            pages: [],
            questions: {},
            answers: {}
          }
        }
      })
    }
  ],
  actions: {
    [NEW_SURVEY] ({dispatch}) {
      let newSurvey = {
        name: 'Nowa Ankieta',
        pages_attributes: [{
          title: 'Nowa Ankieta',
          questions_attributes: [{
            question: 'Nowe Pytanie',
            question_type: "textfield",
            answers_attributes: [{
              answer: 'Opcja'
            }]
          }]
        }]
      }
      return dispatch(NEW, {model: surveyModel, selected: true, ...newSurvey})
    },
    [NEW_PAGE] ({dispatch}, {surveyId, questionIds = [], insertAt}) {
      let newPage = {
        title: 'New Page',
        sort_order_position: insertAt,
        relationships: {
          survey: {
            data: {
              type: surveyModel,
              id: surveyId
            }
          },
        }
      }
      return new Promise((res, rej) => {
        dispatch(NEW, {model: pageModel, selected: true, ...newPage}).then((savedNewPage) => {
          savedNewPage._jv.relationships.questions.data = questionIds.map(id => ({type: questionModel, id}))
          dispatch(PATCH_RELATED, {item: savedNewPage, parentRelName: 'questions', childIdName: 'page_id'}).then((data) => {
            res(data)
          }).catch(rej)
        }).catch(rej)
      })
    },
    [NEW_QUESTION] ({dispatch}, {pageId, questionType = "textfield", insertAt}) {
      let newQuestion = {
        question: 'New Question',
        question_type: questionType,
        answers_attributes: [{
          answer: 'Option 1'
        }],
        sort_order_position: insertAt,
        relationships: {
          page: {
            data: {
              type: pageModel,
              id: pageId
            }
          }
        }
      };
      return dispatch(NEW, {model: questionModel, selected: true, ...newQuestion});
    },
    [NEW_SUBMISSION] ({dispatch, state}, {surveyId}) {
      let relationships = {
        survey: {
          data: {
            type: surveyModel,
            id: surveyId
          }
        },
        person: {
          data: {
            id: state.user.id,
            type: personModel
          }
        }
      };
      return dispatch(NEW, {model: submissionModel, relationships, selected: true})
    },
    [CLEAR_SURVEY_SUBMISSIONS] ({dispatch}, {itemOrId}) {
      let id = getId(itemOrId)
      return new Promise((res, rej) => {
        dispatch('jv/delete', `${surveyModel}/{${id}}/${submissionModel}`).then((maybeData) => {
          res(maybeData);
        }).catch(rej)
      });
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
        unassigned: item.unassigned,
        // FIX - why do we want to do any sorting in the duplicates since the render also does a sort?
        // pages_attributes: getOrderedRelationships('pages', item).map(p => ({
        pages_attributes: Object.values(item.pages).sort((a, b) => a.sort_order - b.sort_order).map(p => ({
          title: p.title,
          // questions_attributes: getOrderedRelationships('questions', p).map(q => ({
          questions_attributes: Object.values(p.questions).sort((a, b) => a.sort_order - b.sort_order).map(q => ({
            question: q.question,
            question_type: q.question_type,
            mandatory: q.mandatory,
            // answers_attributes: getOrderedRelationships('answers', q).map(a => ({
            answers_attributes: Object.values(q.answers).sort((a, b) => a.sort_order - b.sort_order).map(a => ({
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
        page_id: item.page_id,
        question: item.question,
        question_type: item.question_type,
        mandatory: item.mandatory,
        text_size: item.text_size,
        horizontal: item.horizontal,
        private: item.private,
        regex: item.regex,
        // answers_attributes: getOrderedRelationships('answers', item).map(a => ({
        answers_attributes: Object.values(item.answers).sort((a, b) => a.sort_order - b.sort_order).map(a => ({
          answer: a.answer,
          default: a.default,
          other: a.other,
        }))
      }
      if (insertAt) {
        newQuestion.sort_order_position = insertAt
      }
      let relationships= {
        page: {
          data: {
            id: item.page_id,
            type: pageModel
          }
        }
      }
      return new Promise((res, rej) => {
        // TODO maybe someday instead of re-fetching the survey, we should cache the loaded questions with a local mirror instead?
        dispatch(NEW, {model: questionModel, selected: true, relationships, ...newQuestion}).then((data) => {
          dispatch(FETCH_SELECTED, {model: surveyModel}).then(res).catch(rej)
        }).catch(rej)
      })
    },
  }
}
