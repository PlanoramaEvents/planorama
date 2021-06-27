import { survey_columns, Surveys } from './survey';
import { PlanoStore, SELECT } from '../model.store'
import { SurveySubmission } from './survey_response';
export const SELECT_PAGE = "SELECT PAGE";
export const SELECT_QUESTION = "SELECT QUESTION";
export const UNSELECT_PAGE = "UNSELECT PAGE";
export const UNSELECT_QUESTION = "UNSELECT QUESTION";
export const NEW_QUESTION = "NEW QUESTION";
export const NEW_PAGE = "NEW PAGE";
export const NEW_SUBMISSION = "NEW SUBMISSION";
export const UNSELECT_SUBMISSION = "UNSELECT SUBMISSION";
export const SUBMIT = "SUBMIT";

export const store = new PlanoStore('surveys', new Surveys(), survey_columns, {
  selected_page: undefined,
  selected_question: undefined,
  submission: undefined
}, {
  [SELECT] (state, item) {
    // overriding the default one
    state.selected = item;
    if (state.selected_page) {
      state.selected_page = state.selected.survey_pages.find(p => p.id === state.selected_page.id)
    }
    if (state.selected_question) {
      // this will have bugs if you have 2 questions with the same text
      state.selected_question = state.selected_page.survey_questions.find(q => q.question === state.selected_question.question)
    }
  },
  [SELECT_PAGE] (state, page) {
    state.selected_page = page;
    state.selected_question = undefined;
  },
  [UNSELECT_PAGE] (state) {
    state.selected_page = undefined
  },
  [SELECT_QUESTION] (state, question) {
    if (question._destroy) {
      state.selected_question = undefined;
    } else {
      state.selected_question = question;
      state.selected_page = state.selected.survey_pages.find(p => p.id === question.survey_page_id);
    }
  },
  [UNSELECT_QUESTION] (state) {
    state.selected_question = undefined;
  },
  [NEW_SUBMISSION] (state) {
    console.log("new submission!!!")
    state.submission = new SurveySubmission({survey_id: state.selected.id})
  },
  [UNSELECT_SUBMISSION] (state) {
    state.submission = undefined
  }
},{
  [NEW_QUESTION] ({commit, state}, {question, insertAt}) {
    console.log('new question called with', question, insertAt)
    if(!state.selected_page.survey_questions) {
      state.selected_page.survey_questions = []
    }
    state.selected_page.survey_questions.splice(insertAt, 0, question);
    state.selected.save().then(() => {
      let questions = state.selected_page.survey_questions
      let maxId = Math.max(...questions.map(q => q.id));
      let newest_question = quesitons.find(q => q.id === maxId)
      commit(SELECT_QUESTION, newest_question)
    })
  },
  [NEW_PAGE] ({commit, state}, {page, insertAt}) {
    if (!state.selected.survey_pages) {
      state.selected.survey_pages = []
    }
    state.selected.survey_pages.splice(insertAt, 0, page)
    state.selected.save().then(() => {
      let pages = state.selected.survey_pages
      let maxId = Math.max(...pages.map(p => p.id));
      let newest_page = pages.find(p => p.id === maxId)
      commit(SELECT_PAGE, newest_page)
    })
  },
  [SUBMIT] ({state, commit}) {
    state.submission.save().then(() => {
      commit(UNSELECT_SUBMISSION);
    })
  }
});
