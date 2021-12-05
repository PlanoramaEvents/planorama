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
      mergeRecords: 'jv/mergeRecords',
      newResponse: NEW_RESPONSE
    }),
    ...mapActions({
      patch: PATCH_FIELDS,
    }),
    getExistingResponse(relationships) {
      let existingResponses = this.$store.getters['jv/get']({_jv: {
        type: model,
      }}, `$[?(@.question.id=='${relationships.question.data.id}' && @.submission.id=='${relationships.submission.data.id}')]`)
      console.log('existing responses', existingResponses)
      return Object.values(existingResponses)[0]
    },
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
      let existingResponse = this.getExistingResponse(relationships)
      if (existingResponse?.id) {
        return utils.deepCopy(existingResponse)
      }
      // if there's not one, create a new one
      console.debug("getting a new response")
      this.newResponse({relationships});
      return utils.deepCopy(this.getExistingResponse(relationships))
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
