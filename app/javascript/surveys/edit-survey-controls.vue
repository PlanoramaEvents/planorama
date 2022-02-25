<template>
  <div class='position-absolute survey-controls m-3 p-3 border'>
    <b-button v-b-tooltip.left title="Add a Question" variant="info" class="mb-2 d-block" @click="onNewQuestion()" :disabled="!selectedPage"><b-icon-plus-circle></b-icon-plus-circle></b-button>
    <div v-b-tooltip.left title="Import a Question"><b-button disabled variant="info" class="mb-2 d-block"><b-icon-box-arrow-in-right></b-icon-box-arrow-in-right></b-button></div>
    <b-button v-b-tooltip.left title="Add a Page" variant="info" class="mb-2 d-block" @click="onNewPage" :disabled="!selectedPage"><b-icon-hdd-stack></b-icon-hdd-stack></b-button>
    <b-button v-b-tooltip.left title="Add a Horizontal Rule" variant="info" class="mb-2 d-block" @click="onNewQuestion('hr')"><b-icon-hr></b-icon-hr></b-button>
    <b-button v-b-tooltip.left title="Add a Text Block" variant="info" class="d-block" @click="onNewQuestion('textonly')"><b-icon-fonts></b-icon-fonts></b-button>
  </div>
</template>

<script>
import {mapGetters, mapActions} from 'vuex';
import { SELECT, SAVE } from '@/store/model.store';
import { pageModel, questionModel } from '@/store/survey';
import { pageMixin, questionMixin } from '@mixins';

export default {
  name: 'EditSurveyControls',
  mixins: [
    pageMixin, 
    questionMixin
  ],
  methods: {
    onNewQuestion(questionType="textfield") {
      let insertAt = 0;
      if(this.selectedQuestion) {
        insertAt = this.getQuestionIndex(this.selectedQuestion) + 1
      }
      this.newQuestion({pageId: this.selectedPage.id, questionType, insertAt});
    },
    onNewPage() {
      let questionIds=[]
      if (!this.selectedQuestion) {
        // insert a new page with all of the questions in the current page
        questionIds = Object.keys(this.selectedPage.questions)
      } else {
        // insert a new page with the questions below the currently selected question
        let targetSortOrder = this.selectedQuestion.sort_order
        for(let question of this.selectedPageQuestions) {
          if(question.sort_order > targetSortOrder) {
            questionIds.push(question.id)
          }
        }
      }
      let insertAt = Object.keys(this.survey.pages).length
      if (this.selectedPage) {
        // if there's a selected page, insert this page after.
        insertAt = this.getPageIndex(this.selectedPage.id) + 1
      }
      this.newPage({surveyId: this.survey.id, questionIds, insertAt}).then((newPage) => {
        this.fetchSelectedSurvey()
      })
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
