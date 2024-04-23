<!-- CONVERTED -->
<template>
  <b-tab title="Ustawienia">
    <div v-if="survey" class="container">
      <b-row>
        <b-col>
          <span class="mr-2">Zamknięty</span>
          <b-form-checkbox inline v-model="publishVal" switch size="lg" v-b-modal.confirmPublish class="mr-0"></b-form-checkbox>
          Opublikowany&nbsp;<span v-if="survey.public">dnia {{new Date(survey.published_on).toLocaleString()}}</span>
        </b-col>
      </b-row>
      <survey-setting bool v-model="survey.unassigned" field="unassigned">
        Pozwól na wypełnienie ankiety bez przypisania
      </survey-setting>
      <survey-setting bool v-model="survey.mandatory_star" field="mandatory_star">
        Pokaż gwiazdkę dla wymaganych pytań <small>(Jak masz na imię? <span class="text-danger" title="wymagane">*</span>&nbsp;)</small>
      </survey-setting>
      <survey-setting bool disabled v-model="survey.captcha" field="captcha">
        Użyj CAPTCHA
      </survey-setting>
      <survey-setting bool disabled v-model="survey.numbered_questions" field="numbered_questions">
        Pokaż numerację pytań
      </survey-setting>
      <survey-setting bool disabled v-model="survey.branded" field="branded">
        Pokaż logo
      </survey-setting>
      <survey-setting text v-model="survey.submit_string" field="submit_string">
        Tekst na przycisku wyślij
      </survey-setting>
      <survey-setting text v-model="survey.thank_you" field="thank_you">
        Wiadomość potwierdzająca
      </survey-setting>
      <b-modal v-if="survey" id="confirmPublish" @ok="togglePublish" @cancel="cancelPublish" ok-title="Tak" cancel-variant="link">
        <p v-if="survey.public">{{SURVEY_CONFIRM_CLOSE}}</p>
        <p v-if="!survey.public">{{SURVEY_CONFIRM_PUBLISH}}</p>
      </b-modal>
    </div>
    <div v-if="!survey">
      <h3>Ładowanie...</h3>
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
