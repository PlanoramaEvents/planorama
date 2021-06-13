<template>
  <div class="survey-question m-3 border-3">
    <model-field
      label="Title"
      v-model="question.title"
    ></model-field>
    <model-field
      label="Question"
      v-model="question.question"
    ></model-field>
    <model-field
      label="Type"
      v-model="question.question_type"
    ></model-field>
      <!--
        <b-form-textarea 
          v-if="textbox"
          v-model="response.response.text"
          :aria-describedBy="ariaDescribedBy"
          :disabled="!answerable"
        >{{response.response.text}}</b-form-textarea>
        <b-form-input 
          v-if="textfield"
          v-model="response.response.text" 
          :aria-describedBy="ariaDescribedBy"
          :disabled="!answerable"/>
        <b-form-radio-group
          v-if="singlechoice"
          v-model="response.response.text"
          :aria-describedBy="ariaDescribedBy"
        >
          <b-form-radio 
            v-for="choice in choices" 
            :key="choice.id" 
            :value="choice.answer"
            :disabled="!answerable"
          >{{choice.answer}}</b-form-radio>
        </b-form-radio-group>
        <b-form-checkbox-group
          v-if="multiplechoice"
          v-model="response.response.answers"
          :aria-describedBy="ariaDescribedBy"
        >
          <b-form-checkbox 
            v-for="choice in choices" 
            :key="choice.id" 
            :value="choice.answer" 
            :disabled="!answerable"
          >{{choice.answer}}</b-form-checkbox>
        </b-form-checkbox-group>
      </b-form-group>
    </div>
    <div v-if="breakquestion">
      <hr />
    </div>
    -->
  </div>
</template>

<script>
import ModelField from '../model-field.vue'
import { SurveyQuestion } from './survey_question'


export default {
  name: "EditSurveyQuestion",
  components: {
    ModelField,
  },
  props: {
    question: {
      type: SurveyQuestion,
      required: true
    },
  },
  computed: {
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
    selectionbox() {
      return this.question.question_type === "selectionbox";
    },
    breakquestion() {
      return this.question.question_type === "break";
    },
    choices() {
      // todo get this off the question. for now: hardcoded!
      return [{
        id: 1,
        answer: 'Yes',
        default: true,
        sort_order: 1,
        help: 'This means yes.'
      },
      {
        id: 3,
        answer: 'No',
        default: false,
        sort_order: 2,
        help: 'This means no.'
      },
      {
        id: 2,
        answer: 'Future Hazy. Try Again Later.',
        default: false,
        sort_order: 3,
        help: 'What do I look like, some kind of fortune teller?'
      }]
    }
  }
}
</script>
