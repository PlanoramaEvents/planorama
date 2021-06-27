<template>
  <div class="survey-page">
    <h1>{{survey && survey.survey_pages[0].title}}</h1>
    <survey-question
      v-for="q in questions"
      :key="q.id"
      :question="q"
      answerable
    ></survey-question>
    <b-button @click="submit">Submit</b-button>
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
  props: ['survey_id', 'id'],
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
    }
  },
  methods: {
    ...mapMutations({
      unselect: UNSELECT,
      select: SELECT,
      selectPage: SELECT_PAGE,
      newSubmission: NEW_SUBMISSION
    }),
    ...mapActions({
      submit: SUBMIT
    })
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
.survey {
  overflow-y: scroll;
  max-height: calc(100vh - 100px);
}
</style>
