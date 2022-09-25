<template>
  <div>
    <h2>Surveys</h2>
    <survey-table :default-filter='queryString'></survey-table>
 </div>
</template>

<script>
import { modelMixin } from '@/mixins'
import SurveyTable from '../surveys/survey_table';

export default {
  name: 'PeopleSurveysTab',
  components: {
    SurveyTable
  },
  computed: {
    queryString() {
      return '{"queries":[["assigned_people.person_id", "=", "'+this.selected.id+'"]]}';
    }
  },
  mixins: [
    modelMixin
  ],
}
</script>

<style>

</style>
