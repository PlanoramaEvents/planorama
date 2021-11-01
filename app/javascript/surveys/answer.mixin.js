import { mapActions } from "vuex";
import { SAVE } from "../store/model.store";
import { answerModel as model, questionModel } from '../store/survey.store';
import { getId } from "../utils/jsonapi_utils";

export const answerMixin = {
  methods: {
    ...mapActions({
      save: SAVE
    }),
    getAnswersFromServer(questionItemOrId) {
      return this.$store.dispatch('jv/getRelated', {_jv: {
        type: questionModel,
        id: getId(questionItemOrId),
        relationships: {
          survey_answers: undefined
        }
      }});
    },
    saveAnswer(item, update = true) {
      return new Promise((res, rej) => {
        this.save({ model, item, selected: false}).then((data) => {
          if (update) {
            // refresh the answers to the question
            // or it's not working so don't do that
            this.getAnswersFromServer(data.survey_question_id).then(res).catch(rej);
          } else {
            res(data)
          }
        }).catch(rej);
      })
    }
  }
}

export default answerMixin;
