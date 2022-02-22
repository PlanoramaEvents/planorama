<template>
  <div>
    <p>Download responses: <a :href="downloadLink" :download="filename">{{filename}}</a></p>
    <p>There are <em>{{submissions.length}}</em> total responses.</p>
    <ul>
      <li v-for="submission of submissions" :key="submission.id">
        {{new Date(submission.created_at).toLocaleString()}} by {{submission.submitter}}
        <ul>
          <li v-for="response of submission.responses" :key="response.id">
            {{response.question_text}}: {{response.response.text || response.response.answers}}
          </li>
        </ul>
      </li>
    </ul>
  </div>
</template>

<script>
import {
  surveyMixin,
  submissionMixin,
} from '@/mixins';
import { submissionModel, surveyModel } from '@/store/survey';
import { getOrderedRelationships } from '@/utils'
export default {
  name: 'ViewReponses',
  mixins: [
    surveyMixin,
    submissionMixin
  ],
  data: () => ({
  }),
  computed: {
    downloadLink() {
      return `/survey/${this.selectedSurveyId}/submissions.xlsx`
    },
    filename() {
      return `survey_${this.selectedSurveyId}_responses.xlsx`
    },
    submissions() {
      if (!this.selectedSurveyId) {
        return [];
      }
      return Object.values(this.$store.getters['jv/get']({_jv: {type: submissionModel}}), `$[(?@.survey.id=='${this.selectedSurveyId}')]`)
    },
    selectedSurveyId() {
      return this.$store.state.selected[surveyModel];
    }
  },
  watch: {
    selectedSurveyId(newVal, oldVal) {
      if (newVal && (!oldVal || newVal !== oldVal)) {
        this.getSubmissionsForSurvey({id: newVal});
      }
    }
  }
}
</script>

<style>

</style>
