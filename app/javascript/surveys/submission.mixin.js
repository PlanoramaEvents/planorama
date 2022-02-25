import { mapGetters, mapActions, mapMutations } from "vuex";
import { SELECTED, UNSELECT, PATCH_FIELDS } from "@/store/model.store";
import { submissionModel as model, NEW_SUBMISSION, SubmissionStatus } from "@/store/survey";
import { responseModel, surveyModel } from "@/store/survey/survey.model";

// CONVERTED
export const submissionMixin = {
  computed: {
    ...mapGetters({
      selected: SELECTED,
    }),
    selectedSubmission() {
      return this.selected({model});
    },
    // selectedSubmissionResponses() {
    //   // FIX
    //   return getOrderedRelationships('responses', this.selectedSubmission);
    // },
  },
  methods: {
    ...mapMutations({
      unselect: UNSELECT,
    }),
    ...mapActions({
      jvPost: 'jv/post',
      patch: PATCH_FIELDS,
      newSubmission: NEW_SUBMISSION
    }),
    getStoreResponses(submission) {
      return Object.values(this.$store.getters['jv/get']({_jv: {
        type: responseModel
      }}, `$[?(@.submission.id=='${submission.id}')]`));
    },
    submitSelectedSubmission() {
      return new Promise((res, rej) => {
        this.patch({model, item: {...this.selectedSubmission, submission_state: SubmissionStatus.SUBMITTED}, fields: ['submission_state']}).then((data) => {
          Promise.all(this.getStoreResponses(this.selectedSubmission).map(r => this.jvPost(r))).then(() => {
            this.unselect({model})
            res(data)
          }).catch(rej)
        }).catch(rej)
      });
    },
    getSubmissionsForSurvey(survey) {
      // TODO un hard code me
      // this is the stupidest; needs to reload the survey after so it continues to have that data
      // because clearRecords is set; can we unset it on a per call basis?

      // TODO: can we return this collection ?
      // NOTE: this will get all the submissions (not paged, which may be problematic)
      return this.$store.dispatch('jv/getRelated', `${surveyModel}/${survey.id}/submissions`)
      // .then((data) => {
      //   // clear records is no longer set so this is not needed any more
      //   // this.fetchSelectedSurvey();
      // })
    }
  }
}

export default submissionMixin;
