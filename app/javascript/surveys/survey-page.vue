<template>
  <div class="survey-page">
    <h1>{{survey && survey.survey_pages[0].title}}</h1>
    <h2 v-if="survey && survey.survey_pages[0].id != page.id">{{page.title}}</h2>
    <survey-question
      v-for="q in questions"
      :key="q.id"
      :question="q"
      answerable
    ></survey-question>
    <p class="float-right mt-2" v-if="submitted">You submitted the survey! YAY!</p>
    <div class="d-inline float-right mt-2" v-b-tooltip="{disabled: !submit_disabled}" :title="submit_disabled_tooltip">
      <b-button
        variant="primary"
        v-if="!next_page && !submitted"
        @click="submit"
        :disabled="submit_disabled"
      >Submit</b-button>
    </div>
    <b-button class="float-right mt-2" variant="primary" v-if="next_page" @click="next">Next Page</b-button>
  </div>
</template>

<script>
import SurveyQuestion from './survey_question';
import {mapState, mapMutations, mapActions} from 'vuex';
import { UNSELECT, SAVE, SELECT } from '../model.store';
import { NEW_SUBMISSION, SELECT_PAGE, SUBMIT } from './survey.store';
import { Survey } from './survey';

export default {
  name: "SurveyPage",
  props: ['survey_id', 'id', 'preview'],
  data: () =>  ({
    submitted: false
  }),
  components: {
    SurveyQuestion,
  },
  computed: {
    ...mapState({
      page: 'selected_page',
      survey: 'selected',
      surveys: 'collection',
    }),
    questions() {
      return this.page && this.page.survey_questions || [];
    },
    next_page() {
      return this.page && this.page.next_page_id && `/${this.survey_id}/page/${this.page.next_page_id}${this.preview ? '/preview' : ''}`
    },
    submit_disabled() {
      return this.preview || !this.public;
    },
    submit_disabled_tooltip() {
      return this.preview
        ? "This is a preview of the survey. You cannot submit it."
        : "You cannot submit an unpublished survey. Publish the survey to enable."
    }
  },
  methods: {
    ...mapMutations({
      unselect: UNSELECT,
      select: SELECT,
      selectPage: SELECT_PAGE,
      newSubmission: NEW_SUBMISSION
    }),
    submit() {
      if(!this.submit_disabled) {
        this.$store.dispatch(SUBMIT).then(() => {
          this.submitted = true;
        })
      }
    },
    next() {
      this.$router.push(this.next_page);
    },
  },
  beforeRouteUpdate(to, from, next) {
    this.selectPage(this.survey.survey_pages.find(p => p.id == to.params.id))
    next()
  },
  mounted() {
    if (!this.survey && this.survey_id) {
      console.log('trying to load survey id', this.survey_id)
      let model = new Survey({id: this.survey_id}, this.surveys);
      model.fetch().then(() => {
        this.select(model);
        console.log('trying to select page:', this.id)
        this.selectPage(model.survey_pages.find(p => p.id == this.id));
        this.newSubmission();
      });
    }
    else if (!this.page && this.id) {
      this.selectPage(this.survey.survey_pages.find(p => p.id == this.id))
    }
  }
}
</script>

<style lang="scss" scoped>
.survey-page {
  max-width: 50rem;
  overflow-y: auto;
  max-height: calc(100vh - 100px);
}
</style>
