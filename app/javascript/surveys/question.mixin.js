import {mapGetters, mapMutations, mapActions} from 'vuex';
import { getOrderedRelationships } from '../utils/jsonapi_utils';
import { SELECTED, SELECT, UNSELECT, DELETE, SAVE} from '../store/model.store';
import { questionModel as model, NEW_QUESTION, DUPLICATE_QUESTION } from '../store/survey.store';
import { pageMixin } from '@mixins';
import {
  QUESTION_SAVE_SUCCESS
} from '../constants/strings'

// CONVERTED
export const questionMixin = {
  mixins: [
    pageMixin
  ],
  computed: {
    ...mapGetters({
      selected: SELECTED
    }),
    selectedQuestion() {
      return this.selected({model});
    },
    textfield() {
      return this.question.question_type === "textfield";
    },
    textbox() {
      return this.question.question_type === "textbox";
    },
    singlechoice() {
      return this.question.question_type === "singlechoice";
    },
    multiplechoice() {
      return this.question.question_type === "multiplechoice";
    },
    hr() {
      return this.question.question_type === "hr";
    },
    dropdown() {
      return this.question.question_type === "dropdown";
    },
    address() {
      return this.question.question_type === "address";
    },
    email() {
      return this.question.question_type === "email";
    },
    socialmedia() {
      return this.question.question_type === "socialmedia";
    },
    textonly() {
      return this.question.question_type === "textonly";
    },
    otherFromQuestion() {
      return this.getQuestionAnswers(this.question)?.find(a => a.other);
    },
    formatting() {
      return this.textonly || this.hr;
    },
    isSelected() {
      return this.question.id === this.selectedQuestion?.id;
    },
    selectedQuestionIndex() {
      return this.getQuestionIndex(this.selectedQuestion)
    }
  },
  methods: {
    ...mapMutations({
      select: SELECT,
      unselect: UNSELECT,
    }),
    ...mapActions({
      newQuestion: NEW_QUESTION,
      duplicateQuestion: DUPLICATE_QUESTION,
      delete: DELETE,
      save: SAVE
    }),
    saveQuestion(item) {
      return this.save({model, item}).then((data) => {
        console.log(data)
      })
    },
    selectQuestion(itemOrId) {
      this.select({model, itemOrId})
    },
    unselectQuestion() {
      this.unselect({model});
    },
    getQuestionAnswers(question) {
      return getOrderedRelationships('survey_answers', question);
    },
    getQuestionIndex(question) {
      if (!question) {
        return undefined;
      }
      return getOrderedRelationships('survey_questions', question.survey_page).findIndex(q => q.id === question.id)
    },
    duplicateSelectedQuestion() {
      if(!this.selectedQuestion) {
        return Promise.resolve()
      }
      return this.duplicateQuestion({item: this.selectedQuestion, insertAt: this.selectedQuestionIndex + 1})
    },
    deleteSelectedQuestion() {
      if (!this.selectedQuestion) {
        return Promise.resolve()
      }
      return this.delete({model, item: this.selectedQuestion})
    },
    patchQuestion(question, data, message = QUESTION_SAVE_SUCCESS) {
      return this.toastPromise(this.$store.dispatch('jv/patch', { ...data, _jv: {
        id: question.id,
        type: model
      }}), message)
    },
    patchSelectedQuestion(data, message = QUESTION_SAVE_SUCCESS) {
      return this.patchQuestion(this.selectedQuestion, data, message)
    }
  }
}

export default questionMixin;
