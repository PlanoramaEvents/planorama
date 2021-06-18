<template>
  <div class="page">
    <h3>{{page.title}}</h3>
    <edit-survey-question :question="q" v-for="q in page.survey_questions" :key="q.id"></edit-survey-question>
  </div>
</template>

<script>
import EditSurveyQuestion from './edit-survey-question.vue';
import { mapState } from 'vuex';
export default {
  name: "EditSurveyPage",
  components: { EditSurveyQuestion },
  props: {
    page: {
      type: Object,
      required: true
    }
  },
  computed: {
    ...mapState(['selected_page_id']),
    isSelected() {
      return this.page.id === this.selected_page_id;
    }
  }
}
</script>
