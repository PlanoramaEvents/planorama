import { utils } from "jsonapi-vuex"
import { submissionModel, questionModel, responseModel as model } from "@/store/survey"
import { PATCH_FIELDS} from "@/store/model.store"
import { mapActions, mapState, mapMutations } from "vuex"
import { NEW_RESPONSE } from "@/store/survey";

export const responseMixin = {
  data: () => ({
  }),
  computed: {
    ...mapState(['previewMode']),
  },
  methods: {
    ...mapMutations({
      mergeRecords: 'jv/mergeRecords'
    }),
    ...mapActions({
      patch: PATCH_FIELDS,
      newResponse: NEW_RESPONSE
    }),
    getResponse(question, selectedSubmission) {
      console.debug('getting response...')
      if (!question || !selectedSubmission) {
        console.debug('missing one of question or selectedSubmission', this.question, this.selectedSubmission)
        return undefined;
      }
      console.debug("now i have both", this.question, this.selectedSubmission)
      let relationships = {
        question: {
          data: {
            id: question.id,
            type: questionModel
          }
        },
        submission: {
          data: {
            id: selectedSubmission.id,
            type: submissionModel
          }
        }
      }
      let existingResponses = this.$store.getters['jv/get']({_jv: {
        type: model,
      }}, `$[?(@.question.id=='${question.id}' && @.submission.id=='${selectedSubmission.id}')]`)
      console.log('existing responses', existingResponses)
      let existingResponse = Object.values(existingResponses)[0]
      if (existingResponse?.id) {
        return utils.deepCopy(existingResponse)
      }
      // if there's not one, create a new one
      console.debug("getting a new response")
      return utils.deepCopy(this.newResponse({relationships}));
    },
    saveResponse(response){
      // saving the response only
      if (!this.prevewMode) {
        // only save if not in preview mode and if the response was already saved!
        return this.mergeRecords(response);
      }
    }
  }
}

export default responseMixin;
