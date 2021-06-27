<template>
  <div class='float-right survey-controls m-3 p-3 border'>
    <b-button variant="info" class="mb-2 d-block" @click="newQuestion()"><b-icon-plus-circle></b-icon-plus-circle></b-button>
    <b-button variant="info" class="mb-2 d-block"><b-icon-box-arrow-in-right></b-icon-box-arrow-in-right></b-button>
    <b-button variant="info" class="mb-2 d-block" @click="newPage"><b-icon-view-list></b-icon-view-list></b-button>
    <b-button variant="info" class="mb-2 d-block" @click="newQuestion('hr')"><b-icon-hr></b-icon-hr></b-button>
    <b-button variant="info" class="d-block" @click="newQuestion('textonly')"><b-icon-text-left></b-icon-text-left></b-button>
  </div>
</template>

<script>
import { mapState, mapMutations, mapActions } from 'vuex';
import { SAVE } from '../model.store';
import { SELECT_PAGE, SELECT_QUESTION, NEW_PAGE, NEW_QUESTION } from './survey.store';

export default {
  name: 'EditSurveyControls',
  computed: mapState(['selected', 'selected_page', 'selected_question']),
  methods: {
    ...mapMutations({
      selectQuestion: SELECT_QUESTION,
      selectPage: SELECT_PAGE,
    }),
    ...mapActions({
      newQuestionAction: NEW_QUESTION,
      newPageAction: NEW_PAGE
    }),
    newQuestion(question_type="textfield") {
      let insertAt = 0;
      if(this.selected_question) {
        // there might be bugs if the save hasn't come back yet
        insertAt = this.selected_page.survey_questions.findIndex(q => q.id === this.selected_question.id) + 1
      }
      const question = {question: 'New Question', question_type, survey_page_id: this.selected_page.id}
      console.log({question, insertAt})
      this.newQuestionAction({question, insertAt});
    },
    newPage() {
      let insertAt = this.selected.survey_pages.length
      if (this.selected_page) {
        insertAt = this.selected.survey_pages.findIndex(p => p.id === this.selected_page.id) + 1
      }
      const page = {survey_questions: [], title: 'New Page'}
      this.newPageAction({page, insertAt});
    },
  }
}
</script>

<style lang="scss">
.survey-controls {
  background-color: white;
}
</style>
