<template>
  <div class="survey-question mt-3">
    <h3 v-if="question.title">{{question.title}}</h3>
    <b-form-group
      :label="question.question" v-slot="{ ariaDescribedBy }"
    >
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
</template>

<script>
import { SurveyResponse } from './survey_response'

export default {
  name: "SurveyQuestion",
  props: {
    question: {
      type: Object,
      required: true
    },
    response: {
      type: SurveyResponse,
      default() {
        let resp = new SurveyResponse();
        resp.survey_id = this.question.survey_id;
        resp.survey_question_id = this.question.id;
        resp.response = {text: '', answers: []};
        return resp;
      }
    }, 
    answerable: {
      type: Boolean,
      default: false
    }
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
    choices() {
      return this.question.survey_answers;
    }
  }
}
</script>
