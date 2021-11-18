import { mapGetters, mapActions, mapMutations } from "vuex";
import { SELECTED, UNSELECT, PATCH_FIELDS } from "@/store/model.store";
import { submissionModel as model, NEW_SUBMISSION, SubmissionStatus } from "@/store/survey";
import { getOrderedRelationships } from "@/utils/jsonapi_utils";

// CONVERTED
export const submissionMixin = {
  computed: {
    ...mapGetters({
      selected: SELECTED,
    }),
    selectedSubmission() {
      return this.selected({model});
    },
    selectedSubmissionResponses() {
      return getOrderedRelationships('responses', this.selectedSubmission);
    }
  },
  methods: {
    ...mapMutations({
      unselect: UNSELECT,
    }),
    ...mapActions({
      patch: PATCH_FIELDS,
      newSubmission: NEW_SUBMISSION
    }),
    submitSelectedSubmission() {
      return new Promise((res, rej) => {
        this.patch({model, item: {...this.selectedSubmission, submission_state: SubmissionStatus.SUBMITTED}, fields: ['submission_state']}).then((data) => {
          this.unselect({model}) 
          res(data)
        }).catch(rej)
      });
    }
  }
}

export default submissionMixin;
