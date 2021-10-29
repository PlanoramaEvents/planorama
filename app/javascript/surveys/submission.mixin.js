import { mapGetters } from "vuex";
import { SELECTED } from "../store/model.store";
import { submissionModel as model } from '../store/survey.store';

// CONVERTED
export const submissionMixin = {
  computed: {
    ...mapGetters({
      selected: SELECTED
    }),
    selectedSubmission() {
      return this.selected({model});
    }
  }
}

export default submissionMixin;
