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
        <router-link :to="editLink" @click="edit">Edit Questions</router-link>
        <survey-question :question="q" v-for="q in questions" :key="q.id" ></survey-question>
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
import SurveyQuestion from './survey_question';

export default {
  name: 'SurveySidebar',
  components: {
    ModelSidebar,
    SurveyQuestion
  },
  computed: {
    ...mapState({
      survey: 'selected',
    }),
    questions() {
      return this.survey.survey_pages.map(p => p.survey_questions).reduce((p, c) => [...p, ...c],[])
    },
    editLink() {
      return `/edit/${this.survey.id}`
    }
  },
  methods: {
    ...mapActions({
      edit: EDIT
    }),
    save() {
      this.$store.dispatch(SAVE, {item: this.survey});
    },
  }
}
</script>
