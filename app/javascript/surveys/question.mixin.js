import {mapGetters, mapMutations, mapActions} from 'vuex';
import { SELECTED, SELECT, UNSELECT, DELETE, SAVE} from '@/store/model.store';
import { GET_CACHED_INDEX, GET_CACHED_PAGES, GET_CACHED_QUESTIONS, GET_CACHED_ANSWERS } from '../store/survey/survey.store';
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
import settingsMixin from '@/store/settings.mixin';
import {QUESTION_UNCHANGED} from "@/constants/strings";

// CONVERTED
export const questionMixin = {
  mixins: [
    pageMixin,
    surveyMixin,
    settingsMixin
  ],
  data: () => ({
    // if we ever change this, we need to change linked-fields.js too
    questionTypes: [
      { value: 'textfield', text: 'Short Answer'},
      { value: 'textbox', text: 'Long Answer'},
      { value: 'singlechoice', text: 'Multiple Choice' },
      { value: 'multiplechoice', text: 'Checkboxes' },
      { value: 'dropdown', text: 'Dropdown' },
      { value: 'email', text: 'Email' },
      { value: 'socialmedia', text: 'Social Media' },
      { value: 'yesnomaybe', text: 'Three Options Question' },
      { value: 'boolean', text: 'Yes/No' },
      { value: 'attendance_type', text: 'Attendance Type'},
    ],
    saved_question: null,
    saved_question_data: null,
    saved_question_message: null
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
    email() {
      return this.question.question_type === "email";
    },
    socialmedia() {
      return this.question.question_type === "socialmedia";
    },
    textonly() {
      return this.question.question_type === "textonly";
    },
    yesnomaybe() {
      return this.question.question_type === "yesnomaybe";
    },
    boolean() {
      return this.question.question_type === "boolean";
    },
    attendance_type() {
      return this.question.question_type === "attendance_type";
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
    },
    yesLabel() {
      return this.currentSettings?.yesnomaybe?.find(ynm => ynm.value === "yes") || {
        label: "Yes",
        value: "yes"
      }
    },
    noLabel() {
      return this.currentSettings?.yesnomaybe?.find(ynm => ynm.value === "no") || {
        label: "No",
        value: "no"
      }
    },
    maybeLabel() {
      return this.currentSettings?.yesnomaybe?.find(ynm => ynm.value === "maybe") || {
        label: "Yes, except for items focused on the topics listed below.",
        value: "maybe"};
    },
    bYesLabel() {
      return this.currentSettings?.boolean?.find(b => b.value === true) || {
        label: "Yes",
        value: true
      };
    },
    bNoLabel() {
      return this.currentSttings?.boolean?.find(b => b.value === false) || {
        label: "No",
        value: false
      };
    },
    inPersonLabel() {
      return this.currentSettings?.attendance_type?.find(at => at.value === "in_person") || {
        label: "**In-person only:** I am planning to attend in-person",
        value: "in_person"
      }
    },
    virtualLabel() {
      return this.currentSettings?.attendance_type?.find(at => at.value === "virtual") || {
        label: "**Virtual only:** I am not planning to attend in-person, and would like to be a virtual participant on virtual-based items only (via Zoom or similar technology).",
        value: "virtual",
      };
    },
    hybridLabel() {
      return this.currentSettings?.attendance_type?.find(at => at.value === "hybrid") || {
        label: "**In-person and virtual:** I am planning to attend in-person, but would also like to be considered for virtual panels.",
        value: "hybrid"
      }
    }
  },
  methods: {
    ...mapGetters({
      getCachedIndex: GET_CACHED_INDEX,
      getCachedPages: GET_CACHED_PAGES,
      getCachedQuestions: GET_CACHED_QUESTIONS,
      getCachedAnswers: GET_CACHED_ANSWERS
    }),
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
      let cached = this.getCachedAnswers()(question.id)
      if (cached) {
          return cached
      } else {
        return Object.values(question.answers).sort((a, b) => a.sort_order - b.sort_order)
      }
    },
    getQuestionIndex(question) {
      if (!question) {
        return undefined;
      }
      let page = this.getPageById(question.page_id);
      let cached = this.getCachedQuestions()(question.page_id)
      if (cached) {
        return cached.findIndex(q => q.id === question.id);
      } else {
        return Object.values(page.questions).sort((a, b) => a.sort_order - b.sort_order).findIndex(q => q.id === question.id);
      }
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
      if(data.question_type && question.linked_field) {
        // alert("question="+JSON.stringify(question));
        // alert("linked_field="+question.linked_field);
        // alert("data=" + JSON.stringify(data));
        this.saved_question=question;
        this.saved_question_data=data;
        this.saved_question_message=message;
        this.$root.$emit('bv::show::modal', 'unlink-question-modal' )
      } else {
        return this.toastPromise(this.$store.dispatch('jv/patch', {
          ...data, _jv: {
            id: question.id,
            type: model
          }
        }), message)
      }
    },
    patchSelectedQuestion(data, message = QUESTION_SAVE_SUCCESS) {
      return this.patchQuestion(this.selectedQuestion, data, message)
    },
    unlinkQuestion() {
      // alert("unlinking!!");
      this.saved_question_data.linked_field=null;
      delete(this.saved_question.linked_field);
      return this.toastPromise(this.$store.dispatch('jv/patch', {
        ...this.saved_question_data, _jv: {
          id: this.saved_question.id,
          type: model
        }
      }), this.saved_question_message)
    },
    restoreOldValues() {
      //alert("throwing away the attempt to change the question type");
      this.success_toast(QUESTION_UNCHANGED);
    }
  }
}

export default questionMixin;
