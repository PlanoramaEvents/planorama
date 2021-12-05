<template>
  <div>
    <p>Download responses: <a :href="downloadLink" :download="filename">{{filename}}</a></p>
    <p>There are <em>{{submissions.length}}</em> total responses.</p>
    <ul>
      <li v-for="submission of submissions" :key="submission.id">
        {{new Date(submission.created_at).toLocaleString()}} by {{submission.person_id}}
        <ul v-if="getResponses(submission).length">
          <li v-for="response of getResponses(submission)" :key="response.id">{{response.question_id}}: {{response.response.text || response.response.answers}}</li>
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
      return `/surveys/${this.survey?.id}/submissions.xlsx`
    },
    filename() {
      return `survey_${this.survey?.id}_responses.xlsx`
    },
    submissions() {
      if (!this.survey) {
        return [];
      }
      return Object.values(this.$store.getters['jv/get']({_jv: {type: submissionModel}}), `$[(?@.survey.id=='${this.survey.id}')]`)
    },
    selectedSurveyId() {
      return this.$store.state.selected[surveyModel];
    }
  },
  methods: {
    getResponses(submission) {
      return getOrderedRelationships('responses', submission)
    }
  },
  mounted() {
    if(this.survey) {
      this.getSubmissionsForSurvey(this.survey);
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
