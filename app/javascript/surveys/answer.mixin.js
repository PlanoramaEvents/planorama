import { mapActions } from "vuex";
import { SAVE, NEW, DELETE } from "../store/model.store";
import { answerModel as model, questionModel } from '../store/survey.store';
import { getId } from "../utils/jsonapi_utils";

import {
  ANSWER_SAVE_SUCCESS
} from '../constants/strings';

export const answerMixin = {
  methods: {
    ...mapActions({
      save: SAVE,
      new: NEW,
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
    newAnswer(item) {
      return this.new({model, selected: false, ...item})
    },
    saveAnswer(item, update = true) {
      return new Promise((res, rej) => {
        this.save({ model, item, selected: false}).then((data) => {
          if (update) {
            // refresh the answers to the question
            // or it's not working so don't do that
            this.getAnswersFromServer(data.question_id).then(res).catch(rej);
          } else {
            res(data)
          }
        }).catch(rej);
      })
    },
    deleteAnswer(itemOrId) {
      return this.$store.dispatch(DELETE, {model, itemOrId})
    },
    patchAnswer(answer, data, message = ANSWER_SAVE_SUCCESS) {
      return this.toastPromise(this.$store.dispatch('jv/patch', { ...data, _jv: {
        id: answer.id,
        type: model
      }}), message)
    },
  }
}

export default answerMixin;
