import {mapGetters, mapMutations, mapActions} from 'vuex';
import { SELECTED, SELECT, UNSELECT, DELETE, SAVE} from '@/store/model.store';
import { questionModel as model, NEW_QUESTION, DUPLICATE_QUESTION } from '@/store/survey';
import { pageMixin, surveyMixin } from '@/mixins';
import {
  QUESTION_ADD_SAVE_ERROR,
  QUESTION_ADD_SAVE_SUCCESS,
  QUESTION_DELETE_ERROR,
  QUESTION_DELETE_SUCCESS,
  QUESTION_DUPLICATE_ERROR,
  QUESTION_DUPLICATE_SUCCESS,
  QUESTION_SAVE_SUCCESS
} from '../constants/strings'

// CONVERTED
export const questionMixin = {
  mixins: [
    pageMixin,
    surveyMixin
  ],
  data: () => ({
    // if we ever change this, we need to change linked-fields.js too
    questionTypes: [
      { value: 'textfield', text: 'Short Answer'},
      { value: 'textbox', text: 'Long Answer'},
      { value: 'singlechoice', text: 'Multiple Choice' },
      { value: 'multiplechoice', text: 'Checkboxes' },
      { value: 'dropdown', text: 'Dropdown' },
      { value: 'address', text: 'Address' },
      { value: 'email', text: 'Email' },
      { value: 'socialmedia', text: 'Social Media' }
    ],
  }),
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
      newQuestionAction: NEW_QUESTION,
      duplicateQuestion: DUPLICATE_QUESTION,
      delete: DELETE,
      save: SAVE
    }),
    newQuestion(...args) {
      return this.toastPromise(new Promise((res, rej) => {
        this.newQuestionAction(...args).then((data) => {
          this.fetchSelectedSurvey().then(() => res(data)).catch(rej)
        }).catch(rej)
      }), QUESTION_ADD_SAVE_SUCCESS, QUESTION_ADD_SAVE_ERROR);
    },
    saveQuestion(item) {
      return this.save({model, item}).then((data) => {
        console.debug(data)
      })
    },
    selectQuestion(itemOrId) {
      this.select({model, itemOrId})
    },
    unselectQuestion() {
      this.unselect({model});
    },
    getQuestionAnswers(question) {
      return Object.values(question.answers).sort((a, b) => a.sort_order - b.sort_order)
    },
    getQuestionIndex(question) {
      if (!question) {
        return undefined;
      }
      let page = this.getPageById(question.page_id);
      let foo = Object.values(page.questions).sort((a, b) => a.sort_order - b.sort_order).findIndex(q => q.id === question.id);

      return foo;
    },
    duplicateSelectedQuestion() {
      if(!this.selectedQuestion) {
        return Promise.resolve()
      }
      return this.toastPromise(this.duplicateQuestion({item: this.selectedQuestion, insertAt: this.selectedQuestionIndex + 1}), QUESTION_DUPLICATE_SUCCESS, QUESTION_DUPLICATE_ERROR)
    },
    deleteSelectedQuestion() {
      if (!this.selectedQuestion) {
        return Promise.resolve()
      }
      return this.fetchSurveyToastPromise( this.delete({model, itemOrId: this.selectedQuestion}), QUESTION_DELETE_SUCCESS, QUESTION_DELETE_ERROR);
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
