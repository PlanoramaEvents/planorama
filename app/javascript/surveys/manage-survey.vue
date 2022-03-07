<template>
  <div class="survey scrollable">
    <b-button variant="link" @click="back">Back</b-button>
    <h2 class="font-weight-light" v-if="survey">{{survey.name}}</h2>
    <p v-if="survey">{{survey.description}}</p>
    <b-tabs>
      <b-tab title="Questions" :active="!responses" lazy>
        <edit-survey :survey-id="id"></edit-survey>
      </b-tab>
      <b-tab title="Responses" :active="!!responses" lazy>
        <view-responses :survey-id="id"></view-responses>
      </b-tab>
      <survey-settings-tab></survey-settings-tab lazy>
      <b-tab title="Audit Log" disabled lazy>
      </b-tab>
    </b-tabs>
  </div>
</template>

<script>
import { surveyMixin, pageMixin, questionMixin }from '@mixins';
import SurveySettingsTab from './survey-settings-tab.vue';
import NotImplemented from '../shared/not-implemented.vue';
import ViewResponses from './view-responses';
import EditSurvey from './edit-survey';

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
  computed: {
  },
  methods: {
    init() {
      console.debug('MANGE SURVEY INIT')
      this.selectSurvey(this.id)
    },
    back() {
      this.unselectSurvey();
      this.unselectPage();
      this.unselectQuestion();

      // TODO: should this back to surveys ...
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
