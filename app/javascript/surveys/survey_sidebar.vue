<template>
  <div>
    <sidebar-vue v-if="survey" model="survey">
      <template #header>
        <h3>Survey Details</h3>
        <small class="text-muted d-block">Last updated:</small>
        <small class="text-muted d-block"> by <em><strong>{{survey.updated_by && survey.updated_by.name}}</strong></em></small>
        <small class="text-muted d-block"> on <em><strong>{{new Date(survey.updated_at).toLocaleString()}}</strong></em></small>
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
          <icon-button title="Survey Link" :href="surveyLink" target="_blank" icon="globe2"></icon-button>
          <icon-button title="Preview Survey" :href="previewLink" target="_blank" icon="eye-fill"></icon-button>
          <icon-button title="Edit Survey" :to="editLink" :disabled="survey.public" :disabledTooltip="SURVEY_PUBLIC_NO_EDIT" icon="pencil"></icon-button>
          <icon-button icon="envelope" disabled disabledTooltip="Send Survey"></icon-button>
          <!-- <span title="Send Survey"><b-button variant="primary" disabled class="mx-2" title="Send Survey"><b-icon-envelope></b-icon-envelope></b-button></span> -->
          <b-dropdown variant="primary" right no-caret size="sm" class="ml-1">
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
            <b-dd-item v-b-modal.confirmDelete v-b-tooltip.left :title="deleteTitle" :disabled="survey.public">Delete</b-dd-item>
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
import { EDIT, DELETE, DUPLICATE, UNSELECT } from '../store/model.store';
import SurveyQuestion from './survey_question';
import surveyMixin from './survey.mixin';
import SurveySettingsTab from './survey-settings-tab';
import SidebarVue from '../components/sidebar_vue';
import IconButton from '@/components/icon_button.vue';
import {
  SURVEY_RESULTS_CLEAR_CONFIRM,
  SURVEY_SAVE_SUCCESS_DELETE,
  SURVEY_RESULTS_CLEAR_SUCCESS,
  SURVEY_RESULTS_CLEAR_ERROR,
  SURVEY_RESULTS_FREEZE_SUCCESS,
  SURVEY_RESULTS_UNFREEZE_SUCCESS,
  SURVEY_CONFIRM_DELETE,
  SURVEY_PUBLIC_NO_EDIT,
SURVEY_PUBLIC_NO_DELETE
} from '../constants/strings';
import { DUPLICATE_SURVEY } from '@/store/survey';
import { CLEAR_SURVEY_SUBMISSIONS } from '../store/survey/survey.actions';

export default {
  name: 'SurveySidebar',
  components: {
    SidebarVue,
    SurveyQuestion,
    SurveySettingsTab,
    IconButton
  },
  mixins: [
    surveyMixin
  ],
  data: () => ({
    SURVEY_RESULTS_CLEAR_CONFIRM,
    SURVEY_CONFIRM_DELETE,
    SURVEY_PUBLIC_NO_EDIT
  }),
  computed: {
    questions() {
      if (this.selected) {
        return this.getSurveyPages(this.survey).map(
          (p) => {return this.getCachedQuestions()(p.id)}
        ).reduce((p, c) => {
          if (c) {
            return [...p, ...c]
          } else {
            return []
          }
        });
      }
    },
    editLink() {
      return `/surveys/edit/${this.survey.id}`;
    },
    responsesLink() {
      return `${this.editLink}/responses`;
    },
    surveyLink() {
      return `/#/surveys/${this.survey.id}`;
    },
    previewLink() {
      return `${this.surveyLink}/preview`;
    },
    deleteTitle() {
      return this.survey.public ? SURVEY_PUBLIC_NO_DELETE : '';
    }
  },
  methods: {
    ...mapActions({duplicateSurvey: DUPLICATE_SURVEY}),
    destroy() {
      this.deleteSurvey()
    },
    clearResponses() {
      this.toastPromise(this.$store.dispatch(CLEAR_SURVEY_SUBMISSIONS, {itemOrId: this.survey}), SURVEY_RESULTS_CLEAR_SUCCESS, SURVEY_RESULTS_CLEAR_ERROR)
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
