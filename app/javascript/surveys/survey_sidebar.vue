<template>
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
        <b-button v-b-tooltip title="Survey Link" variant="primary"><a :href="surveyLink" target="_blank"><b-icon-link45deg variant="white"></b-icon-link45deg></a></b-button>
        <b-button v-b-tooltip title="Preview Survey" class="mx-2" variant="primary"><a :href="previewLink" target="_blank"><b-icon-eye-fill variant="white"></b-icon-eye-fill></a></b-button>
        <b-button v-b-tooltip title="Edit Survey" variant="primary"><router-link :to="editLink"><b-icon-pencil variant="white"></b-icon-pencil></router-link></b-button>
        <span v-b-tooltip title="Send Survey"><b-button variant="primary" disabled class="mx-2" v-b-tooltip title="Send Survey"><b-icon-envelope></b-icon-envelope></b-button></span>
        <b-dropdown variant="primary" right no-caret>
          <template #button-content>
            <b-icon-three-dots></b-icon-three-dots>
          </template>
          <b-dd-item disabled>View Responses</b-dd-item>
          <b-dd-item disabled>Clear Response</b-dd-item>
          <b-dd-item disabled>Freeze Response Edits</b-dd-item>
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
              <b-form-checkbox inline v-model="survey.public" switch @change="save" >
                Published
              </b-form-checkbox>
              <span v-if="survey.public">on {{new Date(survey.published_on).toLocaleDateString()}}</span>
            </b-col>
          </b-row>
          <b-row>
            <b-col>
              <div class="d-inline-block" v-b-tooltip title="Anonymous is not yet implemented. Check back soon!">
                <b-form-checkbox disabled v-model="survey.anonymous" @change="save">
                  Anonymous
                </b-form-checkbox>
              </div>
            </b-col>
          </b-row>
          <b-row>
            <b-col>

            </b-col>
          </b-row>
        </b-tab>
      </b-tabs>
    </template>
  </sidebar-vuex>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import { SAVE, EDIT, DELETE } from '../model.store';
import SidebarVuex from '../sidebar_vuex';
import SurveyQuestion from './survey_question';

export default {
  name: 'SurveySidebar',
  components: {
    SidebarVuex,
    SurveyQuestion
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
    save() {
      this.$store.dispatch(SAVE, {item: this.survey});
    },
  }
}
</script>

<style lang="scss" scoped>
 
</style>
