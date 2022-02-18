import {questionMixin, surveyMixin} from '@/mixins';
//import { linkedFields } from './linked-fields';

export const linkedMixin = {
  mixins: [questionMixin, surveyMixin],
  data: {
    cachedLinkedValue: null
  },
  methods: {
    /*
    isLinkedFieldDisabled(question_type, value) {
      return this.surveyLinkedFields.includes(value) || !linkedFields[question_type]?.find(l => l.value === value);
    },
    */
    linkField(value) {
      if(!this.selectedQuestion) {
        console.error("cannot link a field; there is no question selected")
        return;
      }
      console.debug("Linking", value, "to", this.selectedQuestion.question)
      if (value) {
        this.surveyLinkedFields.push(value)
        this.cachedLinkedValue = value
      } else if (this.cachedLinkedValue) {
        this.surveyLinkedFields.splice(this.surveyLinkedFields.indexOf(value), 1)
        this.cachedLinkedValue = null
      }
      return this.patchSelectedQuestion({linked: value})
    },
    captureLinkedValue(value) {
      this.initialLinkedValue = value;
    },
    unlinkIfLinked(event) {
      if(!event && this.cachedLinkedValue) {
        this.linkField(null);
      }
    }
  }

}
