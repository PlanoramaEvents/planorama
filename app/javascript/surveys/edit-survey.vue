<template>
  <div class="survey">
    <router-link to="/">Back</router-link>
    <edit-survey-question 
      v-for="q in survey.survey_questions"
      :key="q.id"
      :question="q">
    </edit-survey-question>
  </div>
</template>

<script>
import EditSurveyQuestion from './edit-survey-question'
import {mapState, mapMutations, mapActions} from 'vuex';
import { UNSELECT, SAVE } from '../model.store';

export default {
  name: "EditSurvey",
  components: {
    EditSurveyQuestion,
  },
  computed: mapState({
    survey: 'selected'
  }),
  methods: {
    ...mapMutations([UNSELECT]),
    ...mapActions([SAVE])
  }
}
</script>
