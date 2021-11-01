<template>
  <div class='position-absolute survey-controls m-3 p-3 border'>
    <b-button v-b-tooltip.left title="Add a Question" variant="info" class="mb-2 d-block" @click="newQuestion()" :disabled="!selectedQuestion && !selected_page"><b-icon-plus-circle></b-icon-plus-circle></b-button>
    <div v-b-tooltip.left title="Import a Question"><b-button disabled variant="info" class="mb-2 d-block"><b-icon-box-arrow-in-right></b-icon-box-arrow-in-right></b-button></div>
    <b-button v-b-tooltip.left title="Add a Page" variant="info" class="mb-2 d-block" @click="newPage" :disabled="!selectedQuestion && !selected_page"><b-icon-hdd-stack></b-icon-hdd-stack></b-button>
    <b-button v-b-tooltip.left title="Add a Horizontal Rule" variant="info" class="mb-2 d-block" @click="newQuestion('hr')"><b-icon-hr></b-icon-hr></b-button>
    <b-button v-b-tooltip.left title="Add a Text Block" variant="info" class="d-block" @click="newQuestion('textonly')"><b-icon-fonts></b-icon-fonts></b-button>
  </div>
</template>

<script>
import { SAVE } from '../model.store';
import {mapGetters, mapActions} from 'vuex';
import { SELECT } from '../store/model.store';
import { pageModel, questionModel } from '../store/survey.store';
import { SELECT_PAGE, SELECT_QUESTION, NEW_PAGE, NEW_QUESTION } from './survey.store';

export default {
  name: 'EditSurveyControls',
  computed: mapGetters(['selectedSurvey', 'selectedPage', 'selectedQuestion']),
  methods: {
    ...mapActions({
      newQuestionAction: NEW_QUESTION,
      newPageAction: NEW_PAGE
    }),
    selectQuestion(itemOrId) {
      return this.$store.commit(SELECT, {model: questionModel, itemOrId})
    },
    selectPage(itemOrId) {
      return this.$store.commit(SELECT, {model: pageModel, itemOrId})
    },
    newQuestion(question_type="textfield") {
      let insertAt = 0;
      if(this.selectedQuestion) {
        // there might be bugs if the save hasn't come back yet
        insertAt = this.selectedPage.survey_questions.findIndex(q => q.id === this.selected_question.id) + 1
      }
      const question = {question: 'New Question', question_type, page_id: this.selected_page.id, survey_answers: [{answer: 'Option 1'}]}
      console.log({question, insertAt})
      this.newQuestionAction({question, insertAt});
    },
    newPage() {
      let extracted_question_ids=[]
      if (!this.selected_question) {
        // insert a new page with all of the questions in the current page
        extracted_question_ids = this.selected_page.survey_questions.map(q => q.id);
      } else {
        // insert a new page with the questions below the currently selected question
        let extract_questions = false;
        for(let question of this.selected_page.survey_questions) {
          if (extract_questions) {
            extracted_question_ids.push(question.id)
          } else {
            if (question.id == this.selected_question.id) {
              extract_questions = true;
            }
          }
        }
      }
      let insertAt = this.selected.survey_pages.length
      if (this.selected_page) {
        insertAt = this.selected.survey_pages.findIndex(p => p.id === this.selected_page.id) + 1
      }
      const page = {survey_questions: this.selected.extractQuestions(extracted_question_ids), title: 'New Page'}
      this.newPageAction({page, insertAt});
    },
  }
}
</script>

<style lang="scss">
.survey-controls {
  box-shadow: 5px 5px 10px gray;
  background-color: white;
  top: 30%;
  right: 4rem;
  z-index: 1000;
}
</style>
