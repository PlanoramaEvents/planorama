import { mapGetters, mapActions, mapMutations } from "vuex";
import { SELECTED, SAVE, UNSELECT } from "../store/model.store";
import { submissionModel as model, NEW_SUBMISSION } from "@/store/survey";
import { getOrderedRelationships } from "../utils/jsonapi_utils";

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
      save: SAVE,
      newSubmission: NEW_SUBMISSION
    }),
    submitSelectedSubmission() {
      return new Promise((res, rej) => {
        this.save({model, item: this.selectedSubmission, selected: false}).then((data) => {
          this.unselect({model}) 
          res(data)
        }).catch(rej)
      });
    }
  }
}

export default submissionMixin;
