<!-- CONVERTED -->
<template>
  <div class="scrollable">
    <div class="survey-page">
      <h1 v-if="selectedSurveyFirstPage" >{{ selectedSurveyFirstPage.title }}</h1>
      <h2 v-if="!firstPage">{{selectedPage.title}}</h2>
      <survey-question
        v-for="q in selectedPageSurveyQuestions"
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
import pageMixin from './page.mixin';
import { surveyIdPropMixinSurveyId } from './survey-id-prop.mixin';
import surveyMixin from './survey.mixin';
import { NEW_SUBMISSION, SAVE_SUBMISSION } from '../store/survey.store'
import SurveyQuestion from './survey_question';
import { mapActions } from 'vuex';

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
  ],
  computed: {
    next_page() {
      return `/${this.survey_id}/page/${this.nextPageId}${this.preview ? '/preview' : ''}`
    },
    submit_disabled() {
      return this.preview || !(this.survey && this.survey.public);
    },
    submit_disabled_tooltip() {
      return this.preview
        ? "This is a preview of the survey. You cannot submit it."
        : "You cannot submit an unpublished survey. Publish the survey to enable."
    }
  },
  methods: {
    ...mapActions({
      newSubmission: NEW_SUBMISSION,
      submit: SAVE_SUBMISSION
    }),
    submit() {
      if(!this.submit_disabled) {
        this.submit().then(() => {
          this.submitted = true;
          this.$router.push(`/${this.survey.id}/thankyou`);
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
      console.log('setting next page id to', id)
      if(!id) {
        console.log('attempting to get actual next page id')
        id = this.getNextPage(this.selectedPage.id)?.id;
        console.log('actual next page id:', id)
      }
      this.nextPageId = id;
    }
  },
  beforeRouteUpdate(to, from, next) {
    this.selectPage(this.survey.survey_pages[to.params.id])
    this.setNextPageId(this.selectedPage?.next_page_id);
    next()
  },
  mounted() {
    console.log('mounting page...')
    this.surveyLoadedPromise.then((surveyLoaded) => {
      if (surveyLoaded) {
        this.newSubmission();
      } else if((!this.selectedPage && this.id) || this.id && this.selectedPage.id != this.id) {
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
