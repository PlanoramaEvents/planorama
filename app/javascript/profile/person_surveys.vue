<template>
  <div class="container-fluid scrollable">
    <h5>Surveys Taken</h5>
    <loading-overlay :loading="loading">
      <ul v-if="surveys.length" class="option-3">
        <li v-for="survey in surveys" :key="survey.id"><router-link :to="{
          name: 'survey_responses',
          params: { id: survey.id, responses: 'responses' },
          query: { person_id: person.id }
        }" target="_blank">{{ survey.name }}</router-link></li>
      </ul>
      <div v-if="!surveys.length" class="mt-3">
        <h5 class="font-italic text-muted">No surveys taken.</h5>
      </div>
    </loading-overlay>
  </div>
</template>

<script>
import LoadingOverlay from '@/components/loading_overlay.vue';
import { personSubmissionMixin } from './person.submission.mixin';
import { mapActions } from 'vuex';
import { GET_PERSON_SURVEYS } from '@/store/person.store';

export default {
  name: "PeopleSurveysTab",
  components: {
    LoadingOverlay,
  },
  mixins: [
    personSubmissionMixin
  ],
  props: {
    person: {
      required: true
    }
  },
  data: () => ({
    surveys: [],
    loading: false
  }),
  watch: {
    person: {
      handler(person) {
        if(person?.id) {
          this.loading = true;
          this.getPersonSurveys({person}).then(data => {
            const {_jv, ...surveys} = data;
            this.surveys = Object.values(data).map(s => ({name: s.name, id: s.id}))
            this.loading = false;
          })
          // this.getSurveysForPerson(newVal).then(data => {
          //   // I expect this to come back in [{name: "foo", id: "abc123"}]
          //   this.surveys = data;
          //   this.loading = false;
          // })
        }
      },
      immediate: true
    }
  },
  methods: {
    ...mapActions({
      getPersonSurveys: GET_PERSON_SURVEYS
    })
  }
}
</script>

<style scoped lang="scss">
ul {
  padding-left: 0; 
  list-style-type: none;
}
</style>
