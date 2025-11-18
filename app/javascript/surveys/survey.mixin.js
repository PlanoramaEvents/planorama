import {mapGetters, mapState, mapActions} from 'vuex';
import toastMixin from '../mixins/toast-mixin';
import { SAVE, SELECT, SELECTED, FETCH_SELECTED, DELETE, UNSELECT, PATCH_FIELDS } from '../store/model.store';
import { SURVEY_SAVE_ERROR, SURVEY_SAVE_ERROR_DELETE, SURVEY_SAVE_SUCCESS, SURVEY_SAVE_SUCCESS_DELETE } from '../constants/strings'
import { surveyModel as model} from '@/store/survey';
import { GET_CACHED_INDEX, GET_CACHED_PAGES, GET_CACHED_QUESTIONS, GET_CACHED_ANSWERS } from '../store/survey/survey.store';

export const surveyMixin = {
  mixins: [toastMixin],
  computed: {
    ...mapGetters({
      selected: SELECTED
    }),
    survey() {
      return this.selected({model});
    },
    selectedSurveyPageNbr() {
      if (!this.survey) return 0
      return this.getNbrSurveyPages(this.survey)
    },
    selectedSurveyPages() {
      if (!this.survey) return []
      return this.getSurveyPages(this.survey)
    },
    selectedSurveyFirstPage() {
      return this.survey && this.selectedSurveyPages[0];
    },
    selectedSurveyLastPage() {
      return this.survey && this.selectedSurveyPages[this.getNbrSurveyPages(this.survey) - 1];
    }
  },
  methods: {
    ...mapGetters({
      getCachedIndex: GET_CACHED_INDEX,
      getCachedPages: GET_CACHED_PAGES,
      // The following have args
      getCachedQuestions: GET_CACHED_QUESTIONS,
      getCachedAnswers: GET_CACHED_ANSWERS
    }),
    ...mapActions({
      patch: PATCH_FIELDS
    }),
    saveSurvey(newSurvey, success_text = SURVEY_SAVE_SUCCESS, error_text = SURVEY_SAVE_ERROR) {
      if (!newSurvey) {
        newSurvey = this.survey;
      }
      let fields = Object.keys(newSurvey._jv.attrs);
      return this.toastPromise(this.$store.dispatch(PATCH_FIELDS, {model, selected: true, item: newSurvey, fields: fields}), success_text, error_text)
    },
    selectSurvey(itemOrId) {
      this.$store.commit(SELECT, {model, itemOrId});
    },
    unselectSurvey() {
      this.$store.commit(UNSELECT, {model})
    },
    fetchSelectedSurvey() {
      return this.$store.dispatch(FETCH_SELECTED, {model});
    },
    deleteSurvey(itemOrId, success_text = SURVEY_SAVE_SUCCESS_DELETE, error_text = SURVEY_SAVE_ERROR_DELETE) {
      if (!itemOrId) {
        itemOrId = this.survey;
      }
      return this.toastPromise(this.$store.dispatch(DELETE, {model, itemOrId}), success_text, error_text);
    },
    getNbrSurveyPages(survey) {
      if (survey.pages) {
        return Object.values(survey.pages).length
      } else {
        return 0
      }
    },
    getSurveyPages(survey) {
      if (survey.pages) {
        let pages = this.getCachedPages()
        if (pages && (pages.length > 0)) {
          return pages
        } else {
          return Object.values(survey.pages).sort((a, b) => a.sort_order - b.sort_order)
        }
      } else {
        return []
      }
    },
    patchSurveyField(survey, field, success_text = SURVEY_SAVE_SUCCESS, error_text = SURVEY_SAVE_ERROR) {
      console.debug("attempting to patch survey field", field, "with value", survey[field])
      this.toastPromise(this.patch({model, item: survey, fields: [field]}), success_text, error_text)
    },
    fetchSurveyToastPromise(promise, success_text, error_text) {
      return this.toastPromise(new Promise((res, rej) => {
        promise.then((data) => {
          this.fetchSelectedSurvey().then(()=> res(data)).catch(rej)
        }).catch(rej)
      }), success_text, error_text);
    }
  }
}

export default surveyMixin;
