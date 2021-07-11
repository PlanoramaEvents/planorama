<template>
  <b-tab title="Settings">
    <div v-if="survey" class="container">
      <b-row>
        <b-col>
          <span class="mr-2">Closed</span>
          <b-form-checkbox inline v-model="survey.public" switch size="lg" v-b-modal.confirmPublish class="mr-0"></b-form-checkbox>
          Published&nbsp;<span v-if="survey.$.public">on {{new Date(survey.published_on).toLocaleDateString()}}</span>
        </b-col>
      </b-row>
      <b-row>
        <b-col>
          <not-implemented>
            <b-form-checkbox disabled v-model="survey.anonymous" @change="save">
              Anonymous
            </b-form-checkbox>
          </not-implemented>
        </b-col>
      </b-row>
      <b-row>
        <b-col>
          <b-form-checkbox v-model="survey.mandatory_star" @change="save">Show star for required questions <small>(What is your name? <span class="text-danger" title="required">*</span>&nbsp;)</small></b-form-checkbox>
        </b-col>
      </b-row>
      <b-modal v-if="survey" id="confirmPublish" @ok="togglePublish" @cancel="cancelPublish" ok-title="Yes" cancel-variant="link">
        <p v-if="!survey.public">{{SURVEY_CONFIRM_CLOSE}}</p>
        <p v-if="survey.public">{{SURVEY_CONFIRM_PUBLISH}}</p>
      </b-modal>
    </div>
    <div v-if="!survey">
      <h3>Loading...</h3>
    </div>
  </b-tab>
</template>

<script>
import surveyMixin from './survey-mixin';
import { 
  SURVEY_CONFIRM_CLOSE, 
  SURVEY_CONFIRM_PUBLISH,
  SURVEY_SAVE_SUCCESS_PUBLISH,
  SURVEY_SAVE_SUCCESS_CLOSE,
} from '../constants/strings';
import NotImplemented from '../not-implemented.vue';

export default {
  name: "SurveySettingsTab",
  components: {
    NotImplemented,
  },
  data: () => ({
    SURVEY_CONFIRM_CLOSE,
    SURVEY_CONFIRM_PUBLISH
  }),
  mixins: [surveyMixin],
  methods: {
    togglePublish() {
      this.survey.public = !this.survey.$.public;
      let message = this.survey.public
        ? SURVEY_SAVE_SUCCESS_PUBLISH
        : SURVEY_SAVE_SUCCESS_CLOSE;
      this.save(this.survey.public, message);
    },
    cancelPublish() {
      this.survey.public = this.survey.$.public;
    },
  }
}
</script>

<style>

</style>
