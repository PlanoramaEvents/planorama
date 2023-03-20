<!-- CONVERTED -->
<template>
  <b-tab title="Settings">
    <div v-if="survey" class="container">
      <b-row>
        <b-col>
          <span class="mr-2">Closed</span>
          <b-form-checkbox inline v-model="publishVal" switch size="lg" v-b-modal.confirmPublish class="mr-0"></b-form-checkbox>
          Published&nbsp;<span v-if="survey.public">on {{new Date(survey.published_on).toLocaleString()}}</span>
        </b-col>
      </b-row>
      <survey-setting bool v-model="survey.unassigned" field="unassigned">
        Allow this survey to be taken without assignment
      </survey-setting>
      <survey-setting bool v-model="survey.mandatory_star" field="mandatory_star">
        Show star for required questions <small>(What is your name? <span class="text-danger" title="required">*</span>&nbsp;)</small>
      </survey-setting>
      <survey-setting bool disabled v-model="survey.captcha" field="captcha">
        Use CAPTCHA
      </survey-setting>
      <survey-setting bool disabled v-model="survey.numbered_questions" field="numbered_questions">
        Show numbers on questions
      </survey-setting>
      <survey-setting bool disabled v-model="survey.branded" field="branded">
        Show logo
      </survey-setting>
      <survey-setting text v-model="survey.submit_string" field="submit_string">
        Text for submit button
      </survey-setting>
      <survey-setting text v-model="survey.thank_you" field="thank_you">
        Confirmation message
      </survey-setting>
      <b-modal v-if="survey" id="confirmPublish" @ok="togglePublish" @cancel="cancelPublish" ok-title="Yes" cancel-variant="link">
        <p v-if="survey.public">{{SURVEY_CONFIRM_CLOSE}}</p>
        <p v-if="!survey.public">{{SURVEY_CONFIRM_PUBLISH}}</p>
      </b-modal>
    </div>
    <div v-if="!survey">
      <h3>Loading...</h3>
    </div>
  </b-tab>
</template>

<script>
import surveyMixin from './survey.mixin';
import {
  SURVEY_CONFIRM_CLOSE,
  SURVEY_CONFIRM_PUBLISH,
  SURVEY_SAVE_SUCCESS_PUBLISH,
  SURVEY_SAVE_SUCCESS_CLOSE,
} from '../constants/strings';
import SurveySetting from './survey-setting.vue';

export default {
  name: "SurveySettingsTab",
  components: {
    SurveySetting,
  },
  data: () => ({
    SURVEY_CONFIRM_CLOSE,
    SURVEY_CONFIRM_PUBLISH,
    publishVal: false,
  }),
  mixins: [surveyMixin],
  methods: {
    togglePublish() {
      let publicValue = this.publishVal;
      console.log(publicValue)
      let message = publicValue
        ? SURVEY_SAVE_SUCCESS_PUBLISH
        : SURVEY_SAVE_SUCCESS_CLOSE;
      this.patchSurveyField({...this.survey, public: publicValue}, 'public', message);
    },
    cancelPublish() {
      this.publishVal = this.survey.public;
    },
  },
  mounted() {
    if (this.survey) {
      this.publishVal = this.survey.public;
    }
  },
  watch: {
    survey(newval) {
      if (newval) {
        this.publishVal = newval.public
      }
    }
  }
}
</script>

<style>

</style>
