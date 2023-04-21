<template>
  <div class="survey-question mt-3 pl-1" v-if="!!localResponse">
    <b-form-group
      v-if="!formatting && !socialmedia"
    >
      <template #label>
        <span v-html="questionText"></span>
        <mandatory-star :mandatory="question.mandatory"></mandatory-star>
        <linked-field-icon :linked_field="question.linked_field"></linked-field-icon>
      </template>
      <template #default="{ ariaDescribedBy }">
        <validation-provider
          mode="eager"
          :rules="rules"
          v-slot="{ valid, errors }"
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
            v-if="yesnomaybe"
            v-model="radioButtonResponse"
            :aria-describedBy="ariaDescribedBy"
            :required="question.mandatory"
            @change="saveResponse(localResponse, selectedSubmission)"
          >
            <b-form-radio :disabled="!answerable" :value="yesLabel.value">{{yesLabel.label}}</b-form-radio>
            <b-form-radio :disabled="!answerable" :value="noLabel.value">{{noLabel.label}}</b-form-radio>
            <b-form-radio :disabled="!answerable" :value="maybeLabel.value">{{maybeLabel.label}}</b-form-radio>
            <div class="ml-4 mt-1 mb-3">
              <b-form-textarea
                :placeholder="SURVEY_YESNOMAYBE_PLACEHOLDER"
                v-model="localResponse.response.text"
                :disabled="!answerable || radioButtonResponse !== maybeLabel.value"
                :required="radioButtonResponse === maybeLabel.value"
                @blur="saveResponse(localResponse, selectedSubmission)"
              >
              </b-form-textarea>
            </div>
          </b-form-radio-group>
          <b-form-radio-group
            :class="{'w-50': answerable}"
            stacked
            v-if="boolean"
            v-model="radioButtonResponse"
            :aria-describedBy="ariaDescribedBy"
            :required="question.mandatory"
            @change="saveResponse(localResponse, selectedSubmission)"
          >
            <b-form-radio :disabled="!answerable" :value="bYesLabel.value">{{bYesLabel.label}}</b-form-radio>
            <b-form-radio :disabled="!answerable" :value="bNoLabel.value">{{bNoLabel.label}}</b-form-radio>
          </b-form-radio-group>
          <b-form-radio-group
            :class="{'w-50': answerable}"
            stacked
            v-if="attendance_type"
            v-model="radioButtonResponse"
            :aria-describedBy="ariaDescribedBy"
            :required="question.mandatory"
            @change="saveResponse(localResponse, selectedSubmission)"
          >
            <b-form-radio :disabled="!answerable" :value="inPersonLabel.value">{{inPersonLabel.label}}</b-form-radio>
            <b-form-radio :disabled="!answerable" :value="virtualLabel.value">{{virtualLabel.label}}</b-form-radio>
            <b-form-radio :disabled="!answerable" :value="hybridLabel.value">{{hybridLabel.label}}</b-form-radio>
          </b-form-radio-group>
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
    <div v-if="textonly" v-html="question.question"></div>
    <hr v-if="hr" />
    <div v-if="socialmedia">
      <span v-html="questionText"></span><mandatory-star :mandatory="question.mandatory"></mandatory-star>
      <linked-field-icon :linked_field="question.linked_field"></linked-field-icon>
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
              <b-input-group-text>youtube.com&sol;</b-input-group-text>
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
import { SURVEY_YESNOMAYBE_PLACEHOLDER } from '@/constants/strings';
import LinkedFieldIcon from './linked-field-icon.vue';

export default {
  name: "SurveyQuestion",
  components: {
    MandatoryStar,
    SimpleSocial,
    EmailField,
    ValidationProvider,
    LinkedFieldIcon
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
    is_valid: true,
    SURVEY_YESNOMAYBE_PLACEHOLDER,
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

      let v = errors[0] ? false : null //(valid ? true : null);
      this.is_valid = errors[0] ? false : true
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
      }
    },
  }
}
</script>
