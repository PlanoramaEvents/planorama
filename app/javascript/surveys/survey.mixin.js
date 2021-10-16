import {mapGetters} from 'vuex';
import toastMixin from '../toast-mixin';
import { SAVE, SELECT, FETCH_SELECTED } from '../store/model.store';
import { SURVEY_SAVE_SUCCESS } from '../constants/strings'
import { surveyModel as model} from '../store/survey.store';

// CONVERTED
const surveyMixin = {
  mixins: [toastMixin],
  computed: {
    ...mapGetters({
      survey: 'selectedSurvey'
    }),
    selectedSurveyFirstPage() {
      return this.survey && Object.values(this.survey.survey_pages).find(p => p.sort_order === 0)
    },
  },
  methods: {
    saveSurvey(newSurvey, success_text = SURVEY_SAVE_SUCCESS) {
      if (!newSurvey) {
        newSurvey = this.survey;
      }
      this.$store.dispatch(SAVE, {model, selected: true, item: newSurvey})
        .then(() => this.success_toast(success_text))
        .catch((error) => this.error_toast(error.message))
    },
    selectSurvey(itemOrId) {
      this.$store.commit(SELECT, {model, itemOrId});
    },
    fetchSelectedSurvey() {
      return this.$store.dispatch(FETCH_SELECTED, {model});
    }
  }
}

export default surveyMixin;
