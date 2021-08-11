import {mapState} from 'vuex';
import toastMixin from '../toast-mixin';
import { SAVE } from '../model.store';
import { SURVEY_SAVE_SUCCESS } from '../constants/strings'

const surveyMixin = {
  mixins: [toastMixin],
  computed: {
    ...mapState('surveys', {
      survey: 'selected'
    }),
  },
  methods: {
    save(event, success_text = SURVEY_SAVE_SUCCESS) {
      this.$store.dispatch(`survey/${SAVE}`, {item: this.survey})
        .then(() => this.success_toast(success_text))
        .catch((error) => this.error_toast(error.message))
    },
  }
}

export default surveyMixin;
