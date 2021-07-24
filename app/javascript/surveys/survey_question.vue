<template>
  <div class="survey-question mt-3 pl-1">
    <b-form-group
      v-if="!isFormatting && !address && !socialmedia"
    >
      <template #label>
        <span class="h5">{{questionText}}<mandatory-star :mandatory="question.mandatory"></mandatory-star></span>
      </template>
      <template #default="{ ariaDescribedBy }">
        <b-form-textarea
          class="w-50"
          v-if="textbox"
          v-model="response.response.text"
          :aria-describedBy="ariaDescribedBy"
          :disabled="!answerable"
        >{{response.response.text}}</b-form-textarea>
        <b-form-input
          class="w-50"
          v-if="textfield"
          v-model="response.response.text"
          :aria-describedBy="ariaDescribedBy"
          :disabled="!answerable"/>
        <b-form-radio-group
          class="w-50"
          stacked
          v-if="singlechoice"
          v-model="radioButtonResponse"
          :aria-describedBy="ariaDescribedBy"
        >
          <b-form-radio
            v-for="choice in choices.filter(a => !a.other)"
            :key="choice.id"
            :value="choice.answer"
            :disabled="!answerable"
          >{{choice.answer}}</b-form-radio>
          <b-form-radio
            class="mt-2"
            v-if="other"
            value="Other"
            v-model="otherChecked"
          >
            <b-form-group
              label="Other"
              label-cols="2"
              :label-for="'other-' + question.id"
              label-class="mt-n2"
            >
              <b-form-input 
                class="mt-n2"
                :id="'other-' + question.id" 
                type="text" 
                v-model="response.response.text"
                :disabled="!answerable || !otherChecked"
              ></b-form-input>
            </b-form-group>
          </b-form-radio>
        </b-form-radio-group>
        <b-form-checkbox-group
          class="w-50"
          stacked
          v-if="multiplechoice"
          v-model="response.response.answers"
          :aria-describedBy="ariaDescribedBy"
        >
          <b-form-checkbox
            v-for="choice in choices.filter(a => !a.other)"
            :key="choice.id"
            :value="choice.answer"
            :disabled="!answerable"
          >{{choice.answer}}</b-form-checkbox>
          <b-form-checkbox
            class="mt-2"
            v-if="other"
            value="Other"
            v-model="otherChecked"
          >
            <b-form-group
              label="Other"
              label-cols="2"
              :label-for="'other-' + question.id"
              label-class="mt-n2"
            >
              <b-form-input 
                class="mt-n2"
                :id="'other-' + question.id" 
                type="text" 
                v-model="response.response.text"
                :disabled="!answerable || !otherChecked"
              ></b-form-input>
            </b-form-group>
          </b-form-checkbox>
        </b-form-checkbox-group>
        <b-form-select
          class="w-50"
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
          class="w-50"
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
    <div class="row" v-if="address">
      <div class="col-12 h5">{{questionText}}<mandatory-star :mandatory="question.mandatory"></mandatory-star></div>
    </div>
    <div class="form-address form-row w-50" v-if="address">
      <div class="col-12 col-sm-6 pt-2">
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
      <div class="col-12 col-sm-6 pt-sm-2">
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
          label="Postal Code"
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
      <span class="h5">{{questionText}}<mandatory-star :mandatory="question.mandatory"></mandatory-star></span>
      <div class="row w-50 ml-0">
        <div class="col-12 px-0">
          <simple-social 
              label="Twitter"
              prepend="@"
              :disabled="!answerable"
              :id="formId('socials-twitter')"
              v-model="response.response.socialmedia.twitter"
            ></simple-social>
          <simple-social 
            label="Facebook"
            :disabled="!answerable"
            :id="formId('socials-facebook')"
            v-model="response.response.socialmedia.facebook"
          >
            <template #prepend>
              <b-input-group-text>facebook.com&sol;</b-input-group-text>
            </template>
          </simple-social>
          <simple-social 
            label="Website" 
            prepend="url"
            :disabled="!answerable"
            :id="formId('socials-website')"
            v-model="response.response.socialmedia.website"
          ></simple-social>
          <simple-social 
            label="Instagram"
            :disabled="!answerable"
            :id="formId('socials-insta')"
            v-model="response.response.socialmedia.instagram"
          >
            <template #prepend>
              <b-input-group-text>instagram.com&sol;</b-input-group-text>
            </template>
          </simple-social>
          <simple-social 
            label="Twitch"
            :disabled="!answerable"
            :id="formId('socials-twitch')"
            v-model="response.response.socialmedia.twitch"
          >
            <template #prepend>
              <b-input-group-text>twitch.tv&sol;</b-input-group-text>
            </template>
          </simple-social>
          <simple-social
            label="YouTube"
            :disabled="!answerable"
            :id="formId('socials-youtube')"
            v-model="response.response.socialmedia.youtube"
          >
            <template #prepend>
              <b-input-group-text>youtube.com&sol;channel&sol;</b-input-group-text>
            </template>
          </simple-social>
          <simple-social 
            label="TikTok"
            prepend="@"
            :disabled="!answerable"
            :id="formId('socials-tiktok')"
            v-model="response.response.socialmedia.tiktok"
          ></simple-social>
          <simple-social
            label="LinkedIn"
            :disabled="!answerable"
            :id="formId('socials-linkedin')"
            v-model="response.response.socialmedia.linkedin"
          >
            <template #prepend>
              <b-input-group-text>linkedin.com&sol;in&sol;</b-input-group-text>
            </template>
          </simple-social>
          <simple-social
            label="Other"
            :disabled="!answerable"
            :id="formId('socials-other')"
            v-model="response.response.socialmedia.other"
          ></simple-social>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import {mapState} from 'vuex'
import MandatoryStar from './mandatory-star.vue';
import SimpleSocial from '../social-media/simple-social.vue';

export default {
  name: "SurveyQuestion",
  components: {
    MandatoryStar,
    SimpleSocial,
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
            tiktok: null, other: null, website: null
          }}
        }
      }
    }, 
    answerable: {
      type: Boolean,
      default: false
    }
  },
  data: () => ({
    otherChecked: false
  }),
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
    other() {
      return  this.question.survey_answers ? this.question.survey_answers.filter(a => a.other).length > 0 : false;
    },
    choices() {
      return this.question.survey_answers;
    },
    isFormatting() {
      return this.textonly || this.hr;
    },
    radioButtonResponse: {
      get() {
        return this.response.response.answers ? this.response.response.answers[0] : null
      },
      set(val) {
        this.response.response.answers = [val]
      }
    }
  },
  methods: {
    formId(string) {
      return `${string}-${this.question.id}`
    },
    formGroupId(string) {
      return `${this.formId(string)}-group`
    },
    linkResponse() {
      if (!this.submission.survey_responses) {
        this.submission.survey_responses = []
      }
      let existing_response = this.submission.survey_responses.find(r => r.survey_question_id == this.response.survey_question_id)
      if (existing_response) {
        this.response = existing_response
      } else {
        this.submission.survey_responses.push(this.response)
      }
    }
  },
  mounted() {
    if (this.submission) {
      this.linkResponse();
    }
  },
  watch: {
    submission(val, oldVal) {
      if (!oldVal && val) {
        this.linkResponse();
      }
    }
  }
}
</script>
