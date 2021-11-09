<!-- CONVERTED? -->
<template>
  <div>
    <sidebar-vue v-if="survey" model="survey">
      <template #header>
        <h3>Survey Details</h3>
        <small class="text-muted d-block">Last updated:</small>
        <small class="text-muted d-block"> by <em><strong>{{survey.updated_by && survey.updated_by.name}}</strong></em></small>
        <small class="text-muted d-block"> on <em><strong>{{new Date(survey.updated_at).toLocaleDateString()}}</strong></em></small>
      </template>
      <template #content v-if="survey">
        <b-row>
          <b-col>
            <h2 class="font-weight-light">{{survey.name}}</h2>
          </b-col>
        </b-row>
        <b-row>
          <b-col>
            <p><strong>Short Description:</strong> {{survey.description}}</p>
          </b-col>
        </b-row>
        <div class="float-right d-flex justify-content-end">
          <b-button title="Survey Link" variant="primary" :href="surveyLink" target="_blank"><b-icon-link45deg variant="white"></b-icon-link45deg></b-button>
          <b-button title="Preview Survey" class="mx-2" variant="primary" :href="previewLink" target="_blank"><b-icon-eye-fill variant="white"></b-icon-eye-fill></b-button>
          <b-button title="Edit Survey" variant="primary" :to="editLink"><b-icon-pencil variant="white"></b-icon-pencil></b-button>
          <span title="Send Survey"><b-button variant="primary" disabled class="mx-2" title="Send Survey"><b-icon-envelope></b-icon-envelope></b-button></span>
          <b-dropdown variant="primary" right no-caret>
            <template #button-content>
              <b-icon-three-dots></b-icon-three-dots>
            </template>
            <b-dd-item @click="responses">View Responses</b-dd-item>
            <b-dd-item v-b-modal.confirmClearResponses>Clear Responses</b-dd-item>
            <b-dd-item @click="toggleSubmissionEdits">{{survey.allow_submission_edits ? 'Freeze' : 'Unfreeze'}} Response Edits</b-dd-item>
            <b-dd-divider></b-dd-divider>
            <b-dd-item @click="duplicate">Duplicate</b-dd-item>
            <b-dd-item disabled>Export</b-dd-item>
            <b-dd-item disabled>Make Template</b-dd-item>
            <b-dd-item disabled>Freeze Survey Edits</b-dd-item>
            <b-dd-item v-b-modal.confirmDelete>Delete</b-dd-item>
          </b-dropdown>
        </div>
        <b-tabs content-class="mt-3" nav-class="border-0" nav-wrapper-class="border-bottom">
          <b-tab title="Questions" active>
            <survey-question :question="q" v-for="q in questions" :key="q.id" ></survey-question>
          </b-tab>
          <survey-settings-tab></survey-settings-tab>
        </b-tabs>
      </template>
    </sidebar-vue>
    <b-modal id="confirmClearResponses" @ok="clearResponses" ok-title="Yes" cancel-variant="link">
      <p>{{SURVEY_RESULTS_CLEAR_CONFIRM}}</p>
    </b-modal>
    <b-modal id="confirmDelete" @ok="destroy" ok-title="Yes" cancel-variant="link" title="Delete survey?">
      <p>{{SURVEY_CONFIRM_DELETE}}</p>
    </b-modal>
  </div>
</template>

<script>
import { mapActions } from 'vuex';
import { EDIT, DELETE, DUPLICATE, UNSELECT } from '../model.store';
import SurveyQuestion from './survey_question';
import surveyMixin from './survey.mixin';
import SurveySettingsTab from './survey-settings-tab';
import SidebarVue from '../components/sidebar_vue';
import { CLEAR_SUBMISSIONS } from './survey.store';
import {
  SURVEY_RESULTS_CLEAR_CONFIRM,
  SURVEY_SAVE_SUCCESS_DELETE,
  SURVEY_RESULTS_CLEAR_SUCCESS,
  SURVEY_RESULTS_FREEZE_SUCCESS,
  SURVEY_RESULTS_UNFREEZE_SUCCESS,
  SURVEY_CONFIRM_DELETE,
} from '../constants/strings';
import { DUPLICATE_SURVEY } from '../store/survey.store';
import { getOrderedRelationships } from '../utils/jsonapi_utils';

export default {
  name: 'SurveySidebar',
  components: {
    SidebarVue,
    SurveyQuestion,
    SurveySettingsTab,
  },
  mixins: [surveyMixin],
  data: () => ({
    SURVEY_RESULTS_CLEAR_CONFIRM,
    SURVEY_CONFIRM_DELETE
  }),
  computed: {
    questions() {
      return this.getSurveyPages(this.survey).map(p => getOrderedRelationships('questions', p)).reduce((p, c) => [...p, ...c], []);
      //return Object.values(this.survey.survey_pages).map(p => p.survey_questions).reduce((p, c) => [...p, ...Object.values(c)],[])
    },
    editLink() {
      return `/surveys/edit/${this.survey.id}`;
    },
    responsesLink() {
      return `/surveys/${this.editLink}/responses`;
    },
    surveyLink() {
      return `/surveys/${this.survey.id}`;
    },
    previewLink() {
      return `${this.surveyLink}/preview`;
    }
  },
  methods: {
    ...mapActions({duplicateSurvey: DUPLICATE_SURVEY}),
    destroy() {
      this.deleteSurvey()
    },
    clearResponses() {
      this.error_toast('Has not been converted from vuemc');
      /*
      this.$store.dispatch(`surveys/${CLEAR_SUBMISSIONS}`, {item: this.survey})
        .then(() => this.success_toast(SURVEY_RESULTS_CLEAR_SUCCESS))
        .catch((error) => {
          console.log(error)
          this.error_toast(error.message)
        });
        */
    },
    toggleSubmissionEdits(val) {
      this.survey.allow_submission_edits = val
      let message = this.val
        ? SURVEY_RESULTS_UNFREEZE_SUCCESS
        : SURVEY_RESULTS_FREEZE_SUCCESS
      this.saveSurvey(this.survey, message)
    },
    responses() {
      this.$router.push(this.responsesLink);
    },
    duplicate() {
      this.duplicateSurvey({item: this.survey}).then((newSurvey) => {
        this.$router.push(`surveys/edit/${newSurvey.id}`)
      }).catch((error) => this.error_toast(error.message));
    }
  }
}
</script>

<style lang="scss" scoped>
 
</style>
