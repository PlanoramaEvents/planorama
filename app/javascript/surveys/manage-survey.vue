<template>
  <div class="survey scrollable">
    <b-button variant="link" @click="back">Back</b-button>
    <!-- TODO: wrap in permission  -->
    <b-form-group
      class="mx-3"
      v-if="survey"
      id="survey-name-group"
      label="Survey Name"
      label-for="survey-name"
    >
      <b-form-input id="survey-name" type="text" v-model="survey.name" @blur="saveSurvey()"></b-form-input>
    </b-form-group>
    <b-form-group
      class="mx-3"
      v-if="survey"
      id="survey-description-group"
      label="Survey Description"
      label-for="survey-description"
    >
      <b-form-textarea id="survey-description" v-model="survey.description" @blur="saveSurvey()"></b-form-textarea>
    </b-form-group>
    <b-alert :show="survey.public" variant="warning" class="alert-bright mx-3">{{SURVEY_PUBLIC_NO_EDIT}}</b-alert>
    <b-tabs>
      <b-tab button-id="questionTab" title="Question" :active="!responses && !survey.public" lazy :disabled="survey.public">
        <edit-survey :survey-id="id"></edit-survey>
      </b-tab>
      <b-tab title="Responses" :active="!!responses" lazy>
        <view-responses :survey-id="id"></view-responses>
      </b-tab>
      <survey-settings-tab lazy></survey-settings-tab>
      <b-tab title="Audit Log" disabled lazy>
      </b-tab>
    </b-tabs>
    <b-tooltip :title="questionsTitle" target="questionTab"></b-tooltip>
  </div>
</template>

<script>
import { surveyMixin, pageMixin, questionMixin }from '@/mixins';
import SurveySettingsTab from './survey-settings-tab.vue';
import NotImplemented from '../shared/not-implemented.vue';
import ViewResponses from './view-responses';
import EditSurvey from './edit-survey';
import { SURVEY_PUBLIC_NO_EDIT } from '@/constants/strings';

export default {
  name: "ManageSurvey",
  props: ['responses', 'id'],
  mixins: [
    surveyMixin,
    pageMixin,
    questionMixin
  ],
  components: {
    SurveySettingsTab,
    NotImplemented,
    ViewResponses,
    EditSurvey
  },
  data: () => ({
    SURVEY_PUBLIC_NO_EDIT
  }),
  computed: {
    questionsTitle() {
      return this.survey.public ? SURVEY_PUBLIC_NO_EDIT : '';
    }
  },
  methods: {
    init() {
      this.selectSurvey(this.id)
    },
    back() {
      this.unselectSurvey();
      this.unselectPage();
      this.unselectQuestion();
      this.$router.push('/surveys');
    }
  },
  mounted() {
    this.init()
  }
}
</script>

<style lang="scss" scoped>
.survey {
  .form-group {
    max-width: 60rem;
  }
}
</style>
