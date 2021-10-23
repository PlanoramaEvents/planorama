import {mapGetters} from 'vuex';
import { getOrderedRelationships } from '../utils/jsonapi_utils';
import { SELECTED } from '../store/model.store';
import { questionModel as model } from '../store/survey.store';

// CONVERTED
const questionMixin = {
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
    other() {
      return this.getQuestionAnswers(this.question)?.find(a => a.other);
    },
    formatting() {
      return this.textonly || this.hr;
    },
    isSelected() {
      return this.question.id === this.selectedQuestion?.id;
    },
  },
  methods: {
    getQuestionAnswers(question) {
      return getOrderedRelationships('survey_answers', question);
    }
  }
}

export default questionMixin;
