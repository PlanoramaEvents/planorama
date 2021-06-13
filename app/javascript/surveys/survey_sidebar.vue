<template>
  <model-sidebar title-field="name"
    :pulled-fields="['public', 'anonymous']"
  >
    <template #public>
      <span class="mr-2">Closed</span>
      <b-form-checkbox inline v-model="survey.public" switch @change="save" >
        Published
      </b-form-checkbox>
      <span v-if="survey.public">on ????</span>
    </template>
    <template #anonymous>
      <b-form-checkbox v-model="survey.anonymous" switch @change="save">
        Anonymous
      </b-form-checkbox>
    </template>
    <template #tabs>
      <b-tab title="Questions">
        <router-link to="/edit" @click="edit">Edit Questions</router-link>
        <survey-question :question="q" v-for="q in survey.survey_questions" :key="q.id" ></survey-question>
      </b-tab>
      <b-tab title="Responses">
        <p>TODO responses</p>
      </b-tab>
    </template>
  </model-sidebar>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import { SAVE, EDIT } from '../model.store';
import ModelSidebar from '../model-sidebar';
import SurveyQuestion from './survey_question_component';

export default {
  name: 'SurveySidebar',
  components: {
    ModelSidebar,
    SurveyQuestion
  },
  computed: mapState({
    survey: 'selected'
  }),
  methods: mapActions({
    save() {
      this.$store.dispatch(SAVE, this.survey);
    },
    edit: EDIT
  })
}
</script>
