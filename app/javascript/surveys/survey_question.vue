<template>
  <div class="survey-question mt-3">
    <b-form-group
      v-if="!isFormatting && !address && !socialmedia"
    >
      <template #label>
        {{questionText}}<mandatory-star :mandatory="question.mandatory"></mandatory-star>
      </template>
      <template #default="{ ariaDescribedBy }">
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
        <b-form-select
          v-if="dropdown"
          v-model="response.response.text"
          :aria-describedby="ariaDescribedBy"
        >
          <b-form-select-option
            v-for="choice in choices"
            :key="choice.id"
            :value="choice.answer"
            :disabled="!answerable"
          >{{choice.answer}}</b-form-select-option>
        </b-form-select>
        <b-form-input
          v-if="email"
          type="email"
          v-model="response.response.text"
          :disabled="!answerable"
          :aria-describedBy="ariaDescribedBy"
        ></b-form-input>
      </template>
    </b-form-group>
    <p v-if="textonly">{{question.question}}</p>
    <hr v-if="hr" />
    <div class="form-address form-row" v-if="address">
      <div class="col-12">{{questionText}}<mandatory-star :mandatory="question.mandatory"></mandatory-star></div>
      <div class="col-12 col-sm-6">
        <b-form-group
          :id="formGroupId('address-1')"
          :label-for="formId('address-1')"
          label="Address 1"
        >
          <b-form-input 
            :disabled="!answerable" 
            :id="formId('address-1')" 
            v-model="response.response.address.street"
          ></b-form-input>
        </b-form-group>
      </div>
      <div class="col-12 col-sm-6">
        <b-form-group
          :id="formGroupId('address-2')"
          :label-for="formId('address-2')"
          label="Address 2"
        >
          <b-form-input 
            :disabled="!answerable" 
            :id="formId('address-2')" 
            v-model="response.response.address.street2"
          ></b-form-input>
        </b-form-group>
      </div>
      <div class="col-12 col-sm-6">
        <b-form-group
          :id="formGroupId('city')"
          :label-for="formId('city')"
          label="City"
        >
          <b-form-input 
            :disabled="!answerable" 
            :id="formId('city')" 
            v-model="response.response.address.city"
          ></b-form-input>
        </b-form-group>
      </div>
      <div class="col-12 col-sm-3">
        <b-form-group
          :id="formGroupId('state')"
          :label-for="formId('state')"
          label="State"
        >
          <b-form-input 
          :disabled="!answerable"
          :id="formId('state')" 
          v-model="response.response.address.state"
        ></b-form-input>
        </b-form-group>
      </div>
      <div class="col-12 col-sm-3">
        <b-form-group
          :id="formGroupId('zip')"
          :label-for="formId('zip')"
          label="ZIP Code"
        >
          <b-form-input 
            :disabled="!answerable"
            :id="formId('zip')"
            v-model="response.response.address.zip"
          ></b-form-input>
        </b-form-group>
      </div>
      <div class="col-12">
        <b-form-group
          :id="formGroupId('country')"
          :label-for="formId('country')"
          label="Country"
        >
          <b-form-input
            :disabled="!answerable"
            :id="formId('country')"
            v-model="response.response.address.country"
          ></b-form-input>
        </b-form-group>
      </div>
    </div>
    <div v-if="socialmedia">
      <span>{{questionText}}<mandatory-star :mandatory="question.mandatory"></mandatory-star></span>
      <twitter v-model="response.response.socialmedia.twitter" :edit="answerable"></twitter>
    </div>
  </div>
</template>

<script>
import Twitter from '../social-media/twitter';
import {mapState} from 'vuex'
import MandatoryStar from './mandatory-star.vue';

export default {
  name: "SurveyQuestion",
  components: {
    Twitter,
    MandatoryStar,
  },
  props: {
    question: {
      type: Object,
      required: true
    },
    response: {
      type: Object,
      default() {
        return {
          survey_question_id: this.question.id,
          response: {text: '', answers: [], address:{
            street: null, street2: null, city: null, 
            state: null, zip: null, country: null
          }, socialmedia: {
            twitter: null, facebook: null, linkedin: null,
            twitch: null, youtube: null, instagram: null,
            flickr: null, reddit: null
          }}
        }
      }
    }, 
    answerable: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    ...mapState({
      submission: 'submission',
      survey: 'selected'
    }),
    questionText() {
      return `${this.question.sort_order + 1}. ${this.question.question}`
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
    choices() {
      return this.question.survey_answers;
    },
    isFormatting() {
      return this.textonly || this.hr;
    }
  },
  methods: {
    formId(string) {
      return `${string}-${this.question.id}`
    },
    formGroupId(string) {
      return `${this.formId(string)}-group`
    },
  },
  mounted() {
    if (this.submission) {
      if (!this.submission.survey_responses) {
        this.submission.survey_responses = []
      }
      this.submission.survey_responses.push(this.response)
    }
  }
}
</script>
