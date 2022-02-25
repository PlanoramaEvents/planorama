<template>
  <div>
    <h2>Surveys</h2>
<!--    <ul>
      <li v-for="role of selected.person_roles" :key="role.id">
        {{ role.role }}
      </li>
    </ul>
    <h2>Mail History</h2>
    <pre>{{ selected.mail_histories }}</pre>-->
    <survey-table :default-filter='queryString'></survey-table>
 </div>
</template>

<script>
import { modelMixin } from '@mixins'
import { getOrderedRelationships } from '../utils/jsonapi_utils'
import SurveyTable from '../surveys/survey_table';
import personSessionMixin from "@/auth/person_session.mixin";

export default {
  name: 'PeopleSurveysTab',
  components: {
    SurveyTable
  },
  props: {
    selectedPerson: Object
  },
  computed: {
    queryString() {
      return '{"queries":[["assigned_people.person_id", "=", "'+this.selectedPerson.id+'"]]}';
    }
  },
  mixins: [
    modelMixin, personSessionMixin
  ],
}
</script>

<style>

</style>
