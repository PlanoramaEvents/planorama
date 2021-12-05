<template>
  <div class="survey scrollable">
    <b-button variant="link" @click="back">Back</b-button>
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
    <b-tabs>
      <b-tab title="Questions" :active="!responses">
        <edit-survey-controls></edit-survey-controls>
        <edit-survey-page
          v-for="(p, i) in selectedSurveyPages"
          :key="p.id" :page="p" :i="i"
          :n="selectedSurveyPages.length">
        </edit-survey-page>
      </b-tab>
      <b-tab title="Responses" :active="!!responses">
        <view-responses></view-responses>
      </b-tab>
      <survey-settings-tab></survey-settings-tab>
      <b-tab title="Audit Log" disabled>
      </b-tab>
    </b-tabs>
  </div>
</template>

<script>
import EditSurveyPage from './edit-survey-page'
import EditSurveyControls from './edit-survey-controls'
import {
  surveyMixin,
  surveyIdPropMixinId
}from '@mixins'
import SurveySettingsTab from './survey-settings-tab.vue';
import NotImplemented from '../shared/not-implemented.vue';
import ViewResponses from './view-responses';

export default {
  name: "EditSurvey",
  props: ['responses'],
  mixins: [
    surveyMixin,
    surveyIdPropMixinId,
  ],
  components: {
    EditSurveyPage,
    EditSurveyControls,
    SurveySettingsTab,
    NotImplemented,
    ViewResponses
  },
  computed: {
  },
  methods: {
    back() {
      // TODO only unselect if not coming from view page
      this.unselectSurvey();
      this.$router.push('/surveys');
    }
  },
}
</script>

<style lang="scss" scoped>
.survey {
  .form-group {
    max-width: 60rem;
  }
}
</style>
