<template>
  <div class="container-fluid scrollable">
    <h5>Surveys Taken</h5>
    <loading-overlay :loading="loading">
      <ul v-if="surveys.length" class="option-3">
        <li v-for="survey in surveys" :key="survey.id">
        <router-link
        v-if="currentUserIsStaff || currentUserIsAdmin"
        :to="{
          name: 'survey_responses',
          params: { id: survey.id, responses: 'responses' },
          query: { person_id: person.id }
        }" target="_blank">{{ survey.name }}</router-link>
          <span v-if="!currentUserIsStaff && !currentUserIsAdmin">{{ survey.name }}</span>
        </li>
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
import { personSessionMixin } from '@/mixins';

export default {
  name: "PeopleSurveysTab",
  components: {
    LoadingOverlay,
  },
  mixins: [
    personSubmissionMixin,
    personSessionMixin
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
      handler(newVal, oldVal) {
        if(newVal?.id && (newVal?.id != oldVal?.id)) {
          console.debug("Get surveys for ", newVal.id)
          this.loading = true;
          
          this.getPersonSurveys({person: newVal}).then(data => {
            const {_jv, ...surveys} = data;
            this.surveys = Object.values(surveys).map(s => ({name: s.name, id: s.id}))
            this.loading = false;
          })
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
