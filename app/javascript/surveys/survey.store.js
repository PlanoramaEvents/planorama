import { survey_columns, Surveys } from './survey';
import { PlanoStore, SELECT } from '../model.store'
export const SELECT_PAGE = "SELECT PAGE";
export const SELECT_QUESTION = "SELECT QUESTION";
export const UNSELECT_PAGE = "UNSELECT PAGE";
export const UNSELECT_QUESTION = "UNSELECT QUESTION";
export const NEW_QUESTION = "NEW QUESTION";
export const NEW_PAGE = "NEW PAGE";

export const store = new PlanoStore(new Surveys(), survey_columns, {
  selected_page: undefined,
  selected_question: undefined
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
  [NEW_PAGE] (state, {page, insertAt}) {
    if (!state.selected.survey_pages) {
      state.selected.survey_pages = []
    }
    state.selected.survey_pages.splice(insertAt, 0, page)
    state.selected_page = page
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
  [NEW_QUESTION] (state, {question, insertAt}) {
    console.log('i am called with', state, question, insertAt)
    if(!state.selected_page.survey_questions) {
      state.selected_page.survey_questions = []
    }
    state.selected_page.survey_questions.splice(insertAt, 0, question);
    state.selected_question = question;
  },
});
