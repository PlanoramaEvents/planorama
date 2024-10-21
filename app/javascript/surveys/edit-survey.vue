<template>
  <div class="survey">
    <edit-survey-controls></edit-survey-controls>
    <edit-survey-page
      v-for="(p, i) in selectedSurveyPages"
      :key="p.id" :page="p" :i="i"
      :n="selectedSurveyPageNbr">
    </edit-survey-page>
  </div>
</template>

<script>
import EditSurveyPage from './edit-survey-page'
import EditSurveyControls from './edit-survey-controls'
import {
  surveyMixin,
  pageMixin,
  questionMixin,
  surveyIdPropMixinId
}from '@/mixins.js'

export default {
  name: "EditSurvey",
  props: {
    surveyId: {
      type: String,
      default: null
    }
  },
  mixins: [
    surveyMixin,
    surveyIdPropMixinId,
    pageMixin,
    questionMixin
  ],
  components: {
    EditSurveyPage,
    EditSurveyControls
  },
  computed: {
  },
  methods: {
    init() {
      console.debug('EDIT SURVEY INIT')
      this.unselectPage();
      this.unselectQuestion();

      if (!this.survey || !this.survey.pages) {
        this.selectSurvey(this.surveyId)
        this.fetchSelectedSurvey().then(() => {
          // Clear all the selected survey elements
        });
      } else {
        // Clear all the selected survey elements
      }
    }
  },
  mounted() {
    this.init()
  }
}
</script>

<style lang="scss" scoped>
.survey {
  .form-group {
    max-width: 60rem;
  }
}
</style>
