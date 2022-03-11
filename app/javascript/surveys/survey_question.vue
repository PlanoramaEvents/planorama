<template>
  <div class="survey-question mt-3 pl-1" v-if="!!localResponse">
    <b-form-group
      v-if="!formatting && !address && !socialmedia"
    >
      <template #label>
        <span v-html="questionText"></span><mandatory-star :mandatory="question.mandatory"></mandatory-star>
      </template>
      <template #default="{ ariaDescribedBy }">
        <validation-provider
          mode="eager"
          :rules="rules"
          v-slot="{ valid, errors, validate }"
        >
          <b-form-textarea
            :class="{'w-50': answerable}"
            v-if="textbox"
            v-model="localResponse.response.text"
            :aria-describedBy="ariaDescribedBy"
            :disabled="!answerable"
            @blur="saveResponse(localResponse, selectedSubmission)"
          >{{localResponse.response.text}}</b-form-textarea>
          <b-form-input
            :class="{'w-50': answerable}"
            v-if="textfield"
            v-model="localResponse.response.text"
            :aria-describedBy="ariaDescribedBy"
            :disabled="!answerable"
            :state="calcValid(errors,valid)"
            @blur="saveResponse(localResponse, selectedSubmission)"
          ></b-form-input>
          <b-form-radio-group
            :class="{'w-50': answerable}"
            stacked
            v-if="singlechoice"
            v-model="radioButtonResponse"
            :aria-describedBy="ariaDescribedBy"
            :required="question.mandatory"
            @change="saveResponse(localResponse, selectedSubmission)"
          >
            <b-form-radio
              v-for="choice in choices.filter(a => !a.other)"
              :key="choice.id"
              :value="choiceValue(choice)"
              :disabled="!answerable"
              @input="changeNextPage($event, choice)"
            >{{choice.answer}}</b-form-radio>
            <b-form-radio
              class="mt-2"
              v-if="otherFromQuestion"
              :value="choiceValue(otherFromQuestion)"
              v-model="otherChecked"
              :disabled="!answerable"
              @input="changeNextPage($event, otherFromQuestion)"
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
                  v-model="localResponse.response.text"
                  :disabled="!answerable || !otherChecked"
                ></b-form-input>
              </b-form-group>
            </b-form-radio>
          </b-form-radio-group>
          <b-form-checkbox-group
            :class="{'w-50': answerable}"
            stacked
            v-if="multiplechoice"
            v-model="localResponse.response.answers"
            :aria-describedBy="ariaDescribedBy"
            :required="question.mandatory"
            @change="saveResponse(localResponse, selectedSubmission)"
          >
            <b-form-checkbox
              v-for="choice in choices.filter(a => !a.other)"
              :key="choice.id"
              :value="choiceValue(choice)"
              :disabled="!answerable"
            >{{choice.answer}}</b-form-checkbox>
            <b-form-checkbox
              class="mt-2"
              v-if="otherFromQuestion"
              :value="choiceValue(otherFromQuestion)"
              :disabled="!answerable"
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
                  v-model="localResponse.response.text"
                  :disabled="!answerable || !otherChecked"
                ></b-form-input>
              </b-form-group>
            </b-form-checkbox>
          </b-form-checkbox-group>
          <b-form-select
            :class="{'w-50': answerable}"
            v-if="dropdown"
            v-model="localResponse.response.text"
            :required="question.mandatory"
            :aria-describedby="ariaDescribedBy"
            @change="saveResponse(localResponse, selectedSubmission)"
          >
            <b-form-select-option
              v-for="choice in choices"
              :key="choice.id"
              :value="choice.answer"
              :disabled="!answerable"
            >{{choice.answer}}</b-form-select-option>
          </b-form-select>
          <email-field
            :class="{'w-50': answerable}"
            v-if="email"
            label-sr-only
            :required="question.mandatory"
            v-model="localResponse.response.text"
            :disabled="!answerable"
            :aria-describedBy="ariaDescribedBy"
            @blur="saveResponse(localResponse, selectedSubmission)"
          ></email-field>
          <b-form-invalid-feedback>{{ errors[0] }}</b-form-invalid-feedback>
        </validation-provider>
      </template>
    </b-form-group>
    <p v-if="textonly">{{question.question}}</p>
    <hr v-if="hr" />
    <div class="row" v-if="address">
      <div class="col-12 h5">{{questionText}}<mandatory-star :mandatory="question.mandatory"></mandatory-star></div>
    </div>
    <div :class="['form-address', 'form-row', { 'w-50': answerable}]" v-if="address">
      <div class="col-12 col-sm-6 pt-2">
        <b-form-group
          :id="formGroupId('address-1')"
          :label-for="formId('address-1')"
          label="Address 1"
          :required="question.mandatory"
        >
          <b-form-input
            :disabled="!answerable"
            :id="formId('address-1')"
            v-model="localResponse.response.address.street"
            @blur="saveResponse(localResponse, selectedSubmission)"
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
            v-model="localResponse.response.address.street2"
            @blur="saveResponse(localResponse, selectedSubmission)"
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
            v-model="localResponse.response.address.city"
            @blur="saveResponse(localResponse, selectedSubmission)"
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
          v-model="localResponse.response.address.state"
          @blur="saveResponse(localResponse, selectedSubmission)"
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
            v-model="localResponse.response.address.zip"
            @blur="saveResponse(localResponse, selectedSubmission)"
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
            v-model="localResponse.response.address.country"
            @blur="saveResponse(localResponse, selectedSubmission)"
          ></b-form-input>
        </b-form-group>
      </div>
    </div>
    <div v-if="socialmedia">
      <span class="h5">{{questionText}}<mandatory-star :mandatory="question.mandatory"></mandatory-star></span>
      <div :class="['row', 'ml-0', {'w-50': answerable}]">
        <div class="col-12 px-0">
          <simple-social
            label="Twitter"
            prepend="@"
            :disabled="!answerable"
            :id="formId('socials-twitter')"
            v-model="localResponse.response.socialmedia.twitter"
            @blur="saveResponse(localResponse, selectedSubmission)"
          ></simple-social>
          <simple-social
            label="Facebook"
            :disabled="!answerable"
            :id="formId('socials-facebook')"
            v-model="localResponse.response.socialmedia.facebook"
            @blur="saveResponse(localResponse, selectedSubmission)"
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
            v-model="localResponse.response.socialmedia.website"
            @blur="saveResponse(localResponse, selectedSubmission)"
          ></simple-social>
          <simple-social
            label="Instagram"
            :disabled="!answerable"
            :id="formId('socials-insta')"
            v-model="localResponse.response.socialmedia.instagram"
            @blur="saveResponse(localResponse, selectedSubmission)"
          >
            <template #prepend>
              <b-input-group-text>instagram.com&sol;</b-input-group-text>
            </template>
          </simple-social>
          <simple-social
            label="Twitch"
            :disabled="!answerable"
            :id="formId('socials-twitch')"
            v-model="localResponse.response.socialmedia.twitch"
            @blur="saveResponse(localResponse, selectedSubmission)"
          >
            <template #prepend>
              <b-input-group-text>twitch.tv&sol;</b-input-group-text>
            </template>
          </simple-social>
          <simple-social
            label="YouTube"
            :disabled="!answerable"
            :id="formId('socials-youtube')"
            v-model="localResponse.response.socialmedia.youtube"
            @blur="saveResponse(localResponse, selectedSubmission)"
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
            v-model="localResponse.response.socialmedia.tiktok"
            @blur="saveResponse(localResponse, selectedSubmission)"
          ></simple-social>
          <simple-social
            label="LinkedIn"
            :disabled="!answerable"
            :id="formId('socials-linkedin')"
            v-model="localResponse.response.socialmedia.linkedin"
            @blur="saveResponse(localResponse, selectedSubmission)"
          >
            <template #prepend>
              <b-input-group-text>linkedin.com&sol;in&sol;</b-input-group-text>
            </template>
          </simple-social>
          <simple-social
            label="Other"
            :disabled="!answerable"
            :id="formId('socials-other')"
            v-model="localResponse.response.socialmedia.other"
            @blur="saveResponse(localResponse, selectedSubmission)"
          ></simple-social>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import MandatoryStar from './mandatory-star.vue';
import SimpleSocial from '../social-media/simple-social.vue';
import EmailField from '../shared/email_field';
import {
  questionMixin,
  surveyMixin,
  submissionMixin,
  responseMixin,
  toastMixin
} from '@mixins';
import { v4 as uuidv4 } from 'uuid';
import { submissionModel } from '@/store/survey';
import { mapState } from 'vuex';
import { ValidationProvider } from 'vee-validate';

export default {
  name: "SurveyQuestion",
  components: {
    MandatoryStar,
    SimpleSocial,
    EmailField,
    ValidationProvider
  },
  mixins: [
    questionMixin,
    surveyMixin,
    submissionMixin,
    responseMixin,
    toastMixin
  ],
  props: {
    question: {
      type: Object,
      required: true
    },
    answerable: {
      type: Boolean,
      default: false
    }
  },
  data: () => ({
    otherChecked: false,
    localResponse: null,
    is_valid: true
  }),
  computed: {
    ...mapState(['previewMode']),
    rules() {
      if (this.question.mandatory) {
        return 'required'
      } else {
        return ''
      }
    },
    questionText() {
      return this.question.question;
      // todo implement question numbering
      // return `${this.question.sort_order + 1}. ${this.question.question}`
    },
    choices() {
      return this.getQuestionAnswers(this.question);
    },
    radioButtonResponse: {
      get() {
        return this.localResponse.response.answers ? this.localResponse.response.answers[0] : null
      },
      set(val) {
        this.localResponse.response.answers = [val]
      }
    },
  },
  methods: {
    calcValid(errors, valid) {
      if (this.rules == '') {
        return null
      }

      let v = errors[0] ? false : (valid ? true : null);
      this.is_valid = v
      return v;
    },
    formId(string) {
      return `${string}-${this.question.id}`
    },
    formGroupId(string) {
      return `${this.formId(string)}-group`
    },
    choiceValue(choice) {
      return `${choice.id}-${choice.answer}`
    },
    changeNextPage(event, choice) {
      if (this.question.branching && this.choiceValue(choice) === event) {
        // console.debug("emitting", choice.next_page_id)
        this.$emit('nextPage', choice.next_page_id)
      }
    },
    createDummyResponse() {
      this.localResponse = {
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
  mounted() {
    if (!this.answerable || this.previewMode) {
      // create dummy response so it stops complaining.
      this.createDummyResponse()
   } else {
      this.localResponse = this.getResponse(this.question, this.selectedSubmission)
      // console.log("*******************", this.localResponse)
   }
  },
  watch: {
    previewMode(newVal) {
      if (newVal) {
        this.createDummyResponse();
      }
    },
    selectedSubmission(newVal) {
      if (newVal) {
        this.localResponse = this.getResponse(this.question, newVal)
        // console.log("*******************111111111", this.localResponse)
      }
    },
  }
}
</script>
