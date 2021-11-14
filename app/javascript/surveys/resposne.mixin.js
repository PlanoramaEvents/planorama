import { utils } from "jsonapi-vuex"
import { submissionModel, questionModel, responseModel as model } from "@/store/survey"
import { PATCH_FIELDS} from "@/store/model.store"
import { mapActions } from "vuex"
import { NEW_RESPONSE } from "@/store/survey";

export const responseMixin = {
  computed: {
    response() {
      console.log('getting response...')
      if (!this.question || !this.selectedSubmission) {
        console.log('missing one of question or selectedSubmission', this.question, this.selectedSubmission)
        return undefined
      }
      console.log("now i have both", this.question, this.selectedSubmission)
      let relationships = {
        question: {
          data: {
            id: this.question.id,
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
      let existingResponse = this.$store.getters['jv/get']({_jv: {
        type: model,
        relationships
      }})
      if (existingResponse?.id) {
        console.log("found an existing response", existingResponse)
        return utils.deepCopy(existingResponse)
      }
      // if there's not one, create a new one
      console.log("getting a new response")
      return new Promise((res, rej) => {
        this.newResponse({relationships}).then((data) => {
          res(utils.deepCopy(data))
        }).catch(rej);
      });
    }
  },
  methods: {
    ...mapActions({
      patch: PATCH_FIELDS,
      newResponse: NEW_RESPONSE
    }),
    saveResponse(){
      // saving this.response.response only
      return this.patch({model, item: this.response, fields: ['response'], selected: false})
    }
  }
}

export default responseMixin;
