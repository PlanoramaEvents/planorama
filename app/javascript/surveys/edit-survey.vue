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
      <b-form-input id="survey-name" type="text" v-model="survey.name" @blur="save"></b-form-input>
    </b-form-group>
    <b-form-group
      class="mx-3"
      v-if="survey"
      id="survey-description-group"
      label="Survey Description"
      label-for="survey-description"
    >
      <b-form-textarea id="survey-description" v-model="survey.description" @blur="save"></b-form-textarea>
    </b-form-group>
    <b-tabs>
      <b-tab title="Questions" :active="!responses">
        <edit-survey-controls></edit-survey-controls>
        <edit-survey-page
          v-for="(p, i) in survey ? survey.survey_pages : []"
          :key="p.id" :page="p" :i="i"
          :n="survey.survey_pages.length">
        </edit-survey-page>
      </b-tab>
      <b-tab title="Responses" :active="!!responses">
        <h1>Coming soon</h1>
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
import {mapState, mapMutations, mapActions} from 'vuex';
import { UNSELECT, SAVE, SELECT } from '../model.store';
import { SELECT_PAGE } from './survey.store';
import { Survey } from './survey';
import surveyMixin from './survey-mixin'
import surveyIdPropMixin from './survey-id-prop-mixin';
import SurveySettingsTab from './survey-settings-tab.vue';
import NotImplemented from '../not-implemented.vue';

export default {
  name: "EditSurvey",
  props: ['responses'],
  mixins: [
    surveyMixin,
    surveyIdPropMixin,
  ],
  components: {
    EditSurveyPage,
    EditSurveyControls,
    SurveySettingsTab,
    NotImplemented,
  },
  methods: {
    ...mapMutations({
      unselect: UNSELECT,
    }),
    back() {
      // TODO only unselect if not coming from view page
      this.$store.commit(UNSELECT);
      this.$router.push('/');
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
