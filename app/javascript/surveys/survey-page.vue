<template>
  <div class="scrollable">
    <div class="survey-page">
      <h1>{{survey && survey.survey_pages[0].title}}</h1>
      <h2 v-if="survey && survey.survey_pages[0].id != page.id">{{page.title}}</h2>
      <survey-question
        v-for="q in questions"
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
import {mapState, mapMutations, mapActions} from 'vuex';
import { UNSELECT, SAVE, SELECT } from '../model.store';
import { NEW_SUBMISSION, SELECT_PAGE, SUBMIT } from './survey.store';
import { Survey } from './survey';
import pageMixin from './page-mixin';

export default {
  name: "SurveyPage",
  props: ['survey_id', 'id', 'preview'],
  data: () =>  ({
    submitted: false,
    nextPageId: null
  }),
  components: {
    SurveyQuestion,
  },
  mixins: [pageMixin],
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
      if(!id) {
        id = this.getNextPage(this.page.id)?.id;
      }
      this.nextPageId = id;
    }
  },
  beforeRouteUpdate(to, from, next) {
    this.selectPage(this.survey.survey_pages.find(p => p.id == to.params.id))
    this.setNextPageId(this.selected_page.next_page_id);
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
        this.setNextPageId(this.selected_page.next_page_id);
      });
    }
    else if (!this.page && this.id) {
      this.selectPage(this.survey.survey_pages.find(p => p.id == this.id))
      this.setNextPageId(this.selected_page.next_page_id);
    }
  }
}
</script>

<style lang="scss" scoped>
.survey-page {
  max-width: 50rem;
  padding-bottom: 10px;
}
</style>
