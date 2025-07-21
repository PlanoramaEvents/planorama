<template>
  <!-- The test for survey is here to deal with timing issues to ensure survey is loaded -->
  <div v-if="survey">
    <div class="scrollable" v-if="is_assigned">
      <div class="survey-page" v-if="selectedPage">
        <b-alert :show="redirMessage" dismissible fade class="mt-3 alert-bright d-flex align-items-center" variant="warning" @dismissed="redirShown()">
          <b-icon-exclamation-triangle class="h3 mb-0 mr-3"></b-icon-exclamation-triangle>
          {{SURVEY_REDIRECT}}
          <b-icon-exclamation-triangle class="h3 mb-0 ml-3"></b-icon-exclamation-triangle>
        </b-alert>
        <h1 v-if="selectedSurveyFirstPage" >{{ selectedSurveyFirstPage.title }}</h1>
        <b-alert show variant="info">{{SURVEY_LINKED_FIELD1}}<linked-field-icon :linked_field="true"></linked-field-icon>{{SURVEY_LINKED_FIELD2}}</b-alert>
        <h2 v-if="!firstPage">{{selectedPage.title}}</h2>
        <v-form as="div" ref="surveyForm" v-slot="{handleSubmit}">
          <form @submit.prevent="handleSubmit(submit)">
            <b-alert show variant="danger" v-if="failed">
              <!-- aka SCROLL UP ASSHAT -->
              <b-icon-exclamation-triangle></b-icon-exclamation-triangle> You must correct all errors on the page to proceed.
            </b-alert>
            <survey-question
                v-for="q in selectedPageQuestions"
                :key="q.id"
                :question="q"
                answerable
                @nextPage="setNextPageId"

            ></survey-question>
            <p class="float-right mt-2" v-if="submitted">You submitted the survey! YAY!</p>
            <b-alert show variant="danger" v-if="failed">
              <!-- aka SCROLL UP ASSHAT -->
              <b-icon-exclamation-triangle></b-icon-exclamation-triangle> You must correct all errors on the page to proceed.
            </b-alert>
            <div class="d-flex justify-content-end mt-2">
              <b-button variant="link" class="mr-1" v-if="!firstPage" @click="prev">Previous Page</b-button>
              <div v-b-tooltip="{disabled: !submit_disabled}" :title="submit_disabled_tooltip">
                <b-button
                    variant="primary"
                    type="submit"
                    :disabled="submit_disabled"
                    v-if="(nextPageId === -1 || !nextPageId && lastPage) && !submitted"
                >{{survey.submit_string || 'Submit'}}</b-button>
              </div>
              <!-- NOTE: both next page and submit buttons use submit action
                   so we can plugin validation. What happens (submit or next)
                   is handled in the action
              -->
              <b-button
                  variant="primary"
                  v-if="nextPageId !== -1 && !lastPage"
                  type="submit"
                  tabindex="1"
              >Next Page !!</b-button>
            </div>
          </form>
        </v-form>
      </div>
    </div>
    <div v-else>
      <h1>{{ SURVEY_NOT_ASSIGNED }}</h1>
    </div>
  </div>
</template>

<script>
import SurveyQuestion from './survey_question';
import { Form as VForm } from 'vee-validate';
import { mapMutations, mapState } from 'vuex';
import {
  pageMixin,
  surveyIdPropMixinSurveyId,
  surveyMixin,
  submissionMixin
} from '@/mixins';
import { SET_PREVIEW_MODE, REDIR_SHOWN } from '@/store/survey';
import personSessionMixin from '../auth/person_session.mixin';
import {SURVEY_NOT_ASSIGNED, SURVEY_LINKED_FIELD1, SURVEY_LINKED_FIELD2, SURVEY_REDIRECT} from "@/constants/strings";
import LinkedFieldIcon from './linked-field-icon';

export default {
  name: "SurveyPage",
  props: ['id', 'preview'],
  data: () =>  ({
    submitted: false,
    nextPageId: null,
    prevPageId: null,
    SURVEY_NOT_ASSIGNED,
    SURVEY_LINKED_FIELD1,
    SURVEY_LINKED_FIELD2,
    SURVEY_REDIRECT,
  }),
  components: {
    SurveyQuestion,
    VForm,
    LinkedFieldIcon
  },
  mixins: [
    surveyMixin,
    pageMixin,
    surveyIdPropMixinSurveyId,
    submissionMixin,
    personSessionMixin
  ],
  computed: {
    ...mapState(['redirMessage']),
    is_assigned() {
      // does not work
      return this.preview || this.currentUser.assigned_surveys[this.surveyId]!=undefined || this.survey.unassigned;
    },
    next_page() {
      return `/surveys/${this.surveyId}/page/${this.nextPageId}${this.preview === "preview" ? '/preview' : ''}`
    },
    submit_disabled() {
      return !!this.preview || !(this.survey && this.survey.public);
    },
    submit_disabled_tooltip() {
      return this.preview
          ? "This is a preview of the survey. You cannot submit it."
          : this.submit_disabled
          ? "You cannot submit an unpublished survey. Publish the survey to enable."
          : '';
    }
  },
  methods: {
    ...mapMutations({
      setPreviewMode: SET_PREVIEW_MODE,
      redirShown: REDIR_SHOWN
    }),
    submit() {
      if (this.nextPageId !== -1 && !this.lastPage) {
        // this.$router.push(this.next_page);
        this.next();
      } else {
        console.log("attempting to submit", this.selectedSubmission);
        if(!this.submit_disabled) {
          this.submitSelectedSubmission().then(() => {
            this.submitted = true;
            this.$router.push(`/surveys/${this.survey.id}/thankyou`);
          })
        }
      }
    },
    next() {
      this.redirShown();
      this.$router.push(this.next_page);
    },
    prev() {
      this.redirShown();
      this.$router.go(-1);
    },
    setNextPageId(id) {
      // console.debug('setting next page id to', id)
      if(!id) {
        // console.debug('attempting to get actual next page id')
        id = this.getNextPage(this.selectedPage.id)?.id;
        // console.debug('actual next page id:', id)
      }
      this.nextPageId = id;
    }
  },
  beforeRouteUpdate(to, from, next) {
    this.selectPage(this.survey.pages[to.params.id])
    this.setNextPageId(this.selectedPage?.next_page_id);
    next()
  },
  beforeRouteEnter(to, from, next) {
    if (from.path === '/') {
      next(`/surveys/${to.params.surveyId}/redir`);
      return;
    }
    next();
  },
  mounted() {
    console.debug('mounting page...')
    this.surveyLoadedPromise.then((surveyLoaded) => {
      // console.debug("i get here! and should have a survey", this.survey)
      // this.setPreviewMode(!!this.preview);
      if (surveyLoaded && this.preview !== "preview") {
        this.newSubmission({surveyId: this.surveyId});
      }
      if((!this.selectedPage && this.id) || (this.id && this.selectedPage.id != this.id)) {
        // console.debug("i am on the wrong page!")
        this.selectPage(this.id);
      }
      this.setNextPageId(this.selectedPage.next_page_id);
    })
  }
}
</script>

<style lang="scss" scoped>
.survey-page {
  max-width: 50rem;
  padding-bottom: 10px;
}
</style>
