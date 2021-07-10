<template>
  <div>
    <sidebar-vuex v-if="survey">
      <template #header>
        <h3>Survey Details</h3>
        <small class="text-muted d-block">Last updated:</small>
        <small class="text-muted d-block"> by <em><strong>{{survey.updated_by.name}}</strong></em></small>
        <small class="text-muted d-block"> on <em><strong>{{new Date(survey.updated_at).toLocaleDateString()}}</strong></em></small>
        <!--<small class="text-muted"><b>Last updated by:</b> {{survey.updated_by.name}} <br />
        <b>Last updated on:</b> {{new Date(survey.updated_at).toLocaleDateString()}}</small> -->
      </template>
      <template #content v-if="survey">
        <b-row>
          <b-col>
          </b-col>
        </b-row>
        <b-row>
          <b-col>
          </b-col>
        </b-row>
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
          <b-button title="Survey Link" variant="primary"><a :href="surveyLink" target="_blank"><b-icon-link45deg variant="white"></b-icon-link45deg></a></b-button>
          <b-button title="Preview Survey" class="mx-2" variant="primary"><a :href="previewLink" target="_blank"><b-icon-eye-fill variant="white"></b-icon-eye-fill></a></b-button>
          <b-button title="Edit Survey" variant="primary"><router-link :to="editLink"><b-icon-pencil variant="white"></b-icon-pencil></router-link></b-button>
          <span title="Send Survey"><b-button variant="primary" disabled class="mx-2" title="Send Survey"><b-icon-envelope></b-icon-envelope></b-button></span>
          <b-dropdown variant="primary" right no-caret>
            <template #button-content>
              <b-icon-three-dots></b-icon-three-dots>
            </template>
            <b-dd-item disabled>View Responses</b-dd-item>
            <b-dd-item disabled>Clear Responses</b-dd-item>
            <b-dd-item @click="toggleSubmissionEdits" disabled>{{survey.allow_submission_edits ? 'Freeze' : 'Unfreeze'}} Response Edits</b-dd-item>
            <b-dd-divider></b-dd-divider>
            <b-dd-item disabled>Duplicate</b-dd-item>
            <b-dd-item disabled>Export</b-dd-item>
            <b-dd-item disabled>Make Template</b-dd-item>
            <b-dd-item disabled>Freeze Survey Edits</b-dd-item>
            <b-dd-item @click="destroy">Delete</b-dd-item>
          </b-dropdown>
        </div>
        <b-tabs content-class="mt-3" nav-class="border-0" nav-wrapper-class="border-bottom">
          <b-tab title="Questions" active>
            <survey-question :question="q" v-for="q in questions" :key="q.id" ></survey-question>
          </b-tab>
          <b-tab title="Settings">
            <b-row>
              <b-col>
                <span class="mr-2">Closed</span>
                <b-form-checkbox inline v-model="survey.public" switch size="lg" v-b-modal.confirmPublish class="mr-0"></b-form-checkbox>
                Published&nbsp;<span v-if="survey.$.public">on {{new Date(survey.published_on).toLocaleDateString()}}</span>
              </b-col>
            </b-row>
            <b-row>
              <b-col>
                <div class="d-inline-block" title="Anonymous is not yet implemented. Check back soon!">
                  <b-form-checkbox disabled v-model="survey.anonymous" @change="save">
                    Anonymous
                  </b-form-checkbox>
                </div>
              </b-col>
            </b-row>
            <b-row>
              <b-col>
                <b-form-checkbox v-model="survey.mandatory_star" @change="save">Show star for required questions <small>(What is your name? <span class="text-danger" title="required">*</span>&nbsp;)</small></b-form-checkbox>
              </b-col>
            </b-row>
          </b-tab>
        </b-tabs>
      </template>
    </sidebar-vuex>
    <b-modal v-if="survey" id="confirmPublish" @ok="togglePublish" @cancel="cancelPublish">
      <p v-if="survey.public">Are you sure you want to close the survey? No one will be able to take it anymore.</p>
      <p v-if="!survey.public">Are you sure you want to publish the survey? People will be able to take it.</p>
    </b-modal>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import { SAVE, EDIT, DELETE } from '../model.store';
import SidebarVuex from '../sidebar_vuex';
import MandatoryStar from './mandatory-star.vue';
import SurveyQuestion from './survey_question';

export default {
  name: 'SurveySidebar',
  components: {
    SidebarVuex,
    SurveyQuestion,
    MandatoryStar
  },
  computed: {
    ...mapState({
      survey: 'selected',
    }),
    questions() {
      return this.survey.survey_pages.map(p => p.survey_questions).reduce((p, c) => [...p, ...c],[])
    },
    editLink() {
      return `/edit/${this.survey.id}`
    },
    surveyLink() {
      return `/page/surveys#/${this.survey.id}`;
    },
    previewLink() {
      return `${this.surveyLink}/preview`;
    }
  },
  methods: {
    ...mapActions({
      edit: EDIT
    }),
    destroy() {
      this.$store.dispatch(DELETE, {item: this.survey})
    },
    save(event, success_text = "Survey successfully saved.") {
      this.$store.dispatch(SAVE, {item: this.survey})
        .then(() => this.success_toast(success_text))
        .catch((error) => this.error_toast(error))
    },
    toggleSubmissionEdits(val) {
      this.survey.allow_submission_edits = val
      let verb = this.val ? 'unfrozen' : 'frozen';
      this.save(val, `Response edits successfully ${verb}.`)
    },
    togglePublish() {
      this.survey.public = !this.survey.$.public;
      console.log("public", this.survey.public)
      let message = this.survey.public
        ? "Survey successfully published."
        : "Survey successfully closed.";
      this.save(this.survey.public, message);
    },
    cancelPublish() {
      this.survey.public = this.survey.$.public;
      console.log("public", this.survey.public)
    },
    success_toast(text) {
      this.$bvToast.toast(text, {
        variant: 'success',
        title: 'Success',
        // toaster: 'planotoaster'
      })
    },
    error_toast(text) {
      this.$bvToast.toast(text, {
        variant: 'danger',
        title: 'Something went wrong',
        // toaster: 'planotoaster'
      })
    }
  }
}
</script>

<style lang="scss" scoped>
 
</style>
