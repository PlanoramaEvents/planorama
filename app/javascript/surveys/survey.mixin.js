import {mapGetters} from 'vuex';
import toastMixin from '../toast-mixin';
import { SAVE, SELECT, SELECTED, FETCH_SELECTED, DELETE } from '../store/model.store';
import { SURVEY_SAVE_SUCCESS, SURVEY_SAVE_SUCCESS_DELETE } from '../constants/strings'
import { surveyModel as model} from '../store/survey.store';
import { getOrderedRelationships } from '../utils/jsonapi_utils';

// CONVERTED
const surveyMixin = {
  mixins: [toastMixin],
  computed: {
    ...mapGetters({
      selected: SELECTED
    }),
    survey() {
      return this.selected({model});
    },
    selectedSurveyFirstPage() {
      return this.survey && Object.values(this.survey.survey_pages).find(p => p.sort_order === 0)
    },
  },
  methods: {
    saveSurvey(newSurvey, success_text = SURVEY_SAVE_SUCCESS) {
      if (!newSurvey) {
        newSurvey = this.survey;
      }
      return this.toastPromise(this.$store.dispatch(SAVE, {model, selected: true, item: newSurvey}), success_text)
    },
    selectSurvey(itemOrId) {
      this.$store.commit(SELECT, {model, itemOrId});
    },
    fetchSelectedSurvey() {
      return this.$store.dispatch(FETCH_SELECTED, {model});
    },
    deleteSurvey(itemOrId, success_text = SURVEY_SAVE_SUCCESS_DELETE) {
      if (!itemOrId) {
        itemOrId = this.survey;
      }
      return this.toastPromise(this.$store.dispatch(DELETE, {model, itemOrId}), success_text);
    },
    getSurveyPages(survey) {
      return getOrderedRelationships('survey_pages', survey);
    }
  }
}

export default surveyMixin;
