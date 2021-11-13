<!-- CONVERTED? -->
<template>
  <div class="survey-question mt-3 pl-1">
    <b-form-group
      v-if="!formatting && !address && !socialmedia"
    >
      <template #label>
        <span class="h5">{{questionText}}<mandatory-star :mandatory="question.mandatory"></mandatory-star></span>
      </template>
      <template #default="{ ariaDescribedBy }">
        <b-form-textarea
          :class="{'w-50': answerable}"
          v-if="textbox"
          v-model="response.response.text"
          :aria-describedBy="ariaDescribedBy"
          :disabled="!answerable"
          :required="question.mandatory"
          @blur="updateSubmission"
        >{{response.response.text}}</b-form-textarea>
        <b-form-input
          :class="{'w-50': answerable}"
          v-if="textfield"
          v-model="response.response.text"
          :aria-describedBy="ariaDescribedBy"
          :disabled="!answerable"
          :required="question.mandatory"
          @blur="updateSubmission"
        ></b-form-input>
        <b-form-radio-group
          :class="{'w-50': answerable}"
          stacked
          v-if="singlechoice"
          v-model="radioButtonResponse"
          :aria-describedBy="ariaDescribedBy"
          :required="question.mandatory"
          @change="updateSubmission"
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
                v-model="response.response.text"
                :disabled="!answerable || !otherChecked"
              ></b-form-input>
            </b-form-group>
          </b-form-radio>
        </b-form-radio-group>
        <b-form-checkbox-group
          :class="{'w-50': answerable}"
          stacked
          v-if="multiplechoice"
          v-model="response.response.answers"
          :aria-describedBy="ariaDescribedBy"
          :required="question.mandatory"
          @change="updateSubmission"
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
                v-model="response.response.text"
                :disabled="!answerable || !otherChecked"
              ></b-form-input>
            </b-form-group>
          </b-form-checkbox>
        </b-form-checkbox-group>
        <b-form-select
          :class="{'w-50': answerable}"
          v-if="dropdown"
          v-model="response.response.text"
          :required="question.mandatory"
          :aria-describedby="ariaDescribedBy"
          @change="updateSubmission"
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
          v-model="response.response.text"
          :disabled="!answerable"
          :aria-describedBy="ariaDescribedBy"
          @blur="updateSubmission"
        ></email-field>
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
            v-model="response.response.address.street"
            @blur="updateSubmission"
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
            @blur="updateSubmission"
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
            @blur="updateSubmission"
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
          @blur="updateSubmission"
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
            @blur="updateSubmission"
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
            @blur="updateSubmission"
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
            v-model="response.response.socialmedia.twitter"
            @blur="updateSubmission"
          ></simple-social>
          <simple-social
            label="Facebook"
            :disabled="!answerable"
            :id="formId('socials-facebook')"
            v-model="response.response.socialmedia.facebook"
            @blur="updateSubmission"
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
            @blur="updateSubmission"
          ></simple-social>
          <simple-social
            label="Instagram"
            :disabled="!answerable"
            :id="formId('socials-insta')"
            v-model="response.response.socialmedia.instagram"
            @blur="updateSubmission"
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
            @blur="updateSubmission"
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
            @blur="updateSubmission"
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
            @blur="updateSubmission"
          ></simple-social>
          <simple-social
            label="LinkedIn"
            :disabled="!answerable"
            :id="formId('socials-linkedin')"
            v-model="response.response.socialmedia.linkedin"
            @blur="updateSubmission"
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
            @blur="updateSubmission"
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
  submissionMixin
} from '@mixins';
import { v4 as uuidv4 } from 'uuid';
import { submissionModel } from '../store/survey.store';

export default {
  name: "SurveyQuestion",
  components: {
    MandatoryStar,
    SimpleSocial,
    EmailField
  },
  mixins: [
    questionMixin,
    surveyMixin,
    submissionMixin
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
    response: {
      id: uuidv4(),
      question_id: null,
      response: {text: '', answers: [], address:{
        street: null, street2: null, city: null,
        state: null, zip: null, country: null
      }, socialmedia: {
        twitter: null, facebook: null, linkedin: null,
        twitch: null, youtube: null, instagram: null,
        tiktok: null, other: null, website: null
      }}
    }
  }),
  computed: {
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
      console.log("trying to link response", this.response)
      let existing_response = this.selectedSubmission.responses_attributes.find(r => r.question_id == this.question.id)
      if (existing_response) {
        console.log("found an existing response!");
        this.response = existing_response
      } else {
        console.log("pushing this response");
        let item = {
          responses_attributes: [
            ...this.selectedSubmission.responses_attributes,
            this.response
          ],
          _jv: {
            type: submissionModel,
            id: this.selectedSubmission.id
          }
        }
        this.$store.commit('jv/mergeRecords', item)
      }
    },
    choiceValue(choice) {
      return `${choice.id}-${choice.answer}`
    },
    changeNextPage(event, choice) {
      if (this.question.branching && this.choiceValue(choice) === event) {
        console.log("emitting", choice.next_page_id)
        this.$emit('nextPage', choice.next_page_id)
      }
    },
    updateSubmission() {
      console.log("updating the submission")
      let item = {
        responses_attributes: [
          ...this.selectedSubmission.responses_attributes.filter(r => r.id !== this.response.id),
          this.response
        ],
        _jv: {
          id: this.selectedSubmission.id,
          type: submissionModel
        }
      }
      this.$store.commit('jv/mergeRecords', item)
    }
  },
  mounted() {
    this.response.question_id = this.question.id;
    if (this.selectedSubmission) {
      this.linkResponse();
    }
  },
  watch: {
    selectedSubmission(val, oldVal) {
      console.log("selected Submission", val)
      if ((!oldVal && val) || (oldVal && oldVal !== val)) {
        this.linkResponse();
      }
    },
    response(val, oldVal) {
      if (val !== oldVal) {
      }
    }
  }
}
</script>
