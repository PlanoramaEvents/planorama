<!-- CONVERTED -->
<template>
  <div class="scrollable">
    <div class="survey-page" v-if="selectedPage">
      <h1 v-if="selectedSurveyFirstPage" >{{ selectedSurveyFirstPage.title }}</h1>
      <h2 v-if="!firstPage">{{selectedPage.title}}</h2>
      <survey-question
        v-for="q in selectedPageQuestions"
        :key="q.id"
        :question="q"
        answerable
        @nextPage="setNextPageId"
      ></survey-question>
      <p class="float-right mt-2" v-if="submitted">You submitted the survey! YAY!</p>
      <div class="d-flex justify-content-end mt-2">
        <b-button variant="link" class="mr-1" v-if="!firstPage" @click="prev">Previous Page</b-button>
        <div v-b-tooltip="{disabled: !submit_disabled}" :title="submit_disabled_tooltip">
          <b-button
            variant="primary"
            v-if="(nextPageId === -1 || !nextPageId && lastPage) && !submitted"
            @click="submit"
            :disabled="submit_disabled"
          >{{survey.submit_string || 'Submit'}}</b-button>
        </div>
        <b-button variant="primary" v-if="nextPageId !== -1 && !lastPage" @click="next" tabindex="1">Next Page</b-button>
      </div>
    </div>
  </div>
</template>

<script>
import SurveyQuestion from './survey_question';
import { mapActions, mapMutations } from 'vuex';
import {
  pageMixin,
  surveyIdPropMixinSurveyId,
  surveyMixin,
  submissionMixin
} from '@mixins';
import { SET_PREVIEW_MODE } from '@/store/survey';

export default {
  name: "SurveyPage",
  props: ['id', 'preview'],
  data: () =>  ({
    submitted: false,
    nextPageId: null
  }),
  components: {
    SurveyQuestion,
  },
  mixins: [
    surveyMixin,
    pageMixin,
    surveyIdPropMixinSurveyId,
    submissionMixin
  ],
  computed: {
    next_page() {
      return `/surveys/${this.surveyId}/page/${this.nextPageId}${this.preview ? '/preview' : ''}`
    },
    submit_disabled() {
      return !!this.preview || !(this.survey && this.survey.public);
    },
    submit_disabled_tooltip() {
      return this.preview
        ? "This is a preview of the survey. You cannot submit it."
        : "You cannot submit an unpublished survey. Publish the survey to enable."
    }
  },
  methods: {
    ...mapMutations({
      setPreviewMode: SET_PREVIEW_MODE
    }),
    submit() {
      console.log("attempting to submit", this.selectedSubmission);
      if(!this.submit_disabled) {
        this.submitSelectedSubmission().then(() => {
          this.submitted = true;
          this.$router.push(`/surveys/${this.survey.id}/thankyou`);
        })
      }
    },
    next() {
      this.$router.push(this.next_page);
    },
    prev() {
      this.$router.go(-1);
    },
    setNextPageId(id) {
      console.debug('setting next page id to', id)
      if(!id) {
        console.debug('attempting to get actual next page id')
        id = this.getNextPage(this.selectedPage.id)?.id;
        console.debug('actual next page id:', id)
      }
      this.nextPageId = id;
    }
  },
  beforeRouteUpdate(to, from, next) {
    this.selectPage(this.survey.pages[to.params.id])
    this.setNextPageId(this.selectedPage?.next_page_id);
    next()
  },
  mounted() {
    console.debug('mounting page...')
    this.surveyLoadedPromise.then((surveyLoaded) => {
      console.debug("i get here! and should have a survey", this.survey)
      this.setPreviewMode(!!this.preview);
      if (surveyLoaded && !this.preview) {
        this.newSubmission({surveyId: this.surveyId});
      }
      if((!this.selectedPage && this.id) || (this.id && this.selectedPage.id != this.id)) {
        console.debug("i am on the wrong page!")
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
