import { utils } from "jsonapi-vuex"
import { submissionModel, questionModel, responseModel as model } from "@/store/survey"
import { PATCH_FIELDS} from "@/store/model.store"
import { mapActions, mapState } from "vuex"
import { NEW_RESPONSE } from "@/store/survey";

export const responseMixin = {
  computed: {
    ...mapState(['previewMode']),
  },
  methods: {
    ...mapActions({
      patch: PATCH_FIELDS,
      newResponse: NEW_RESPONSE
    }),
    getResponse(question) {
      console.debug('getting response...')
      if (!question || !this.selectedSubmission) {
        console.debug('missing one of question or selectedSubmission', this.question, this.selectedSubmission)
        return undefined
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
            id: this.selectedSubmission.id,
            type: submissionModel
          }
        }
      }
      let existingResponses = this.$store.getters['jv/get']({_jv: {
        type: model,
        relationships
      }})
      let existingResponse = Object.values(existingResponses)[0]
      if (existingResponse?.id) {
        console.debug("found an existing response", existingResponse)
        return Promise.resolve(utils.deepCopy(existingResponse))
      }
      // if there's not one, create a new one
      console.debug("getting a new response")
      return new Promise((res, rej) => {
        this.newResponse({relationships}).then((data) => {
          res(utils.deepCopy(data))
        }).catch(rej);
      });
    },
    saveResponse(response){
      // saving the response only
      console.log("attempting to save response", response)
      if (!this.prevewMode && response.id) {
        // only save if not in preview mode and if the response was already saved!
        return this.patch({model, item: response, fields: ['response'], selected: false})
      }
    }
  }
}

export default responseMixin;
