<template>
  <div class="survey-question m-3 border p-3">
    <div v-if="!formatting" class="row">
      <div class="col-6">
        <b-form-group
         :id="formGroupId('question-text')"
         label="Question Text"
         :label-for="formId('question-text')"
        >
          <b-form-input
            :id="formId('question-text')"
            v-model="question.question"
            type="text"
          ></b-form-input>
        </b-form-group>
      </div>
      <div class="col-6">
        <b-form-group
          :id="formGroupId('question-type')"
          label="Question Type"
          :label-for="formId('question-type')"
        >
          <b-form-select :id="formId('question-type')" v-model="question.question_type" :options="questionTypes"></b-form-select>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <template v-if="textfield">
        <div class="col-12">
          <small>Short answer text</small>
        </div>
      </template>
      <template v-if="textbox">
        <div class="col-12">
          <small>Long answer text</small>
        </div>
      </template>
      <template v-if="singlechoice">
        <div class="col-12 pb-2" v-for="a in question.survey_answers" :key="a.id">
          <b-form-radio disabled>
            <b-form-input type="text" v-model="a.answer"></b-form-input>
          </b-form-radio>
        </div>
      </template>
      <template v-if="multiplechoice">
        <div class="col-12 pb-2" v-for="a in question.survey_answers" :key="a.id">
          <b-form-checkbox disabled>
            <b-form-input type="text" v-model="a.answer"></b-form-input>
          </b-form-checkbox>
        </div>
      </template>
      <template v-if="hr">
        <div class="col-12">
          <hr />
        </div>
      </template>
      <template v-if="dropdown">
        <div class="col-12">
          <ol>
            <li class="pb-2" v-for="a in question.survey_answers" :key="a.id">
              <b-form-input v-model="a.answer" type="text"></b-form-input>
            </li>
          </ol>
        </div>
      </template>
      <template v-if="address">
        <div class="col-12 col-sm-6">
          <b-form-group
            :id="formGroupId('address-1')"
            :label-for="formId('address-1')"
            label="Address 1"
          >
            <b-form-input disabled :id="formId('address-1')" value="123 Sesame Street"></b-form-input>
          </b-form-group>
        </div>
        <div class="col-12 col-sm-6">
          <b-form-group
            :id="formGroupId('address-2')"
            :label-for="formId('address-2')"
            label="Address 2"
          >
            <b-form-input disabled :id="formId('address-2')" value="Apt. 2B"></b-form-input>
          </b-form-group>
        </div>
        <div class="col-12 col-sm-6">
          <b-form-group
            :id="formGroupId('city')"
            :label-for="formId('city')"
            label="City"
          >
            <b-form-input disabled :id="formId('city')" value="New York"></b-form-input>
          </b-form-group>
        </div>
        <div class="col-12 col-sm-3">
          <b-form-group
            :id="formGroupId('state')"
            :label-for="formId('state')"
            label="State"
          >
            <b-form-input disabled :id="formId('state')" value="NY"></b-form-input>
          </b-form-group>
        </div>
        <div class="col-12 col-sm-3">
          <b-form-group
            :id="formGroupId('zip')"
            :label-for="formId('zip')"
            label="ZIP Code"
          >
            <b-form-input disabled :id="formId('zip')" value="12345"></b-form-input>
          </b-form-group>
        </div>
        <div class="col-12">
          <b-form-group
            :id="formGroupId('country')"
            :label-for="formId('country')"
            label="Country"
          >
            <b-form-input disabled :id="formId('country')" value="USA"></b-form-input>
          </b-form-group>
        </div>
      </template>
      <template v-if="email">
        <div class="col-12">
          <b-form-input disabled type="email" value="example@example.com"></b-form-input>
        </div>
      </template>
      <template v-if="socialmedia">
        <div class="col-12">
          <b-form-checkbox-group v-model="socialChoice" :options="socials">
          </b-form-checkbox-group>
        </div>
      </template>
      <template v-if="textonly">
        <div class="col-12">
          <b-form-textarea v-model="question.question"></b-form-textarea>
        </div>
      </template>
    </div>
  </div>
</template>

<script>
import { SurveyQuestion } from './survey_question'


export default {
  name: "EditSurveyQuestion",
  data: () => ({
    questionTypes: [
      { value: 'textfield', text: 'Short Answer'},
      { value: 'textbox', text: 'Paragraph'},
      { value: 'singlechoice', text: 'Multiple Choice' },
      { value: 'multiplechoice', text: 'Checkboxes' },
      { value: 'dropdown', text: 'Dropdown' },
      { value: 'address', text: 'Address' },
      { value: 'email', text: 'Email' },
      { value: 'socialmedia', text: 'Social Media' }
    ],
  }),
  props: {
    question: {
      type: Object,
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
    answerIdMap() {
      if(!this.question.question_answers) {
        return {}
      }
      return this.question.question_answers.reduce((p, c) => ({
        ...p,
        [c.answer]: c.id
      }), {});

    },
    socialChoice: {
      get() {
        const answers = this.question.question_answers; 
        return answers ? answers.map(qa => qa.answer) : [];
      },
      set(val) {
        this.question.question_answers = val.map(answer => ({
          answer,
          id: this.answerIdMap[answer] || undefined
        }))
      }
    },
    socials() {
      return [
        {value: "twitter", text: "Twitter"},
        {value: "facebook", text: "Facebook"},
        {value: "linkedin", text: "LinkedIn"},
        {value: "twitch", text: "Twitch"},
        {value: "youtube", text: "YouTube"},
        {value: "instagram", text: "Instagram"},
        {value: "flickr", text: "Flickr"},
        {value: "reddit", text: "Reddit"},
      ]
    },
    formatting() {
      return this.textonly || this.hr;
    },
  },
  methods: {
    formId(string) {
      return `${string}-${this.question.id}`
    },
    formGroupId(string) {
      return `${this.formId(string)}-group`
    }
  }
}
</script>

<style lang="scss">
.custom-control-label {
  width: 100%;
}
</style>
