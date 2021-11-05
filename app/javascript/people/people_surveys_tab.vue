<template>
  <div>
    <h2>Surveys for {{currentUser.name}}</h2>
<!--    <ul>
      <li v-for="role of selected.person_roles" :key="role.id">
        {{ role.role }}
      </li>
    </ul>
    <h2>Mail History</h2>
    <pre>{{ selected.mail_histories }}</pre>-->
    <survey-table></survey-table>
 </div>
</template>

<script>
import { modelMixin } from '@mixins'
import sessionMixin from '../session/session.mixin';
import { getOrderedRelationships } from '../utils/jsonapi_utils'
import SurveyTable from '../surveys/survey_table';

export default {
  name: 'PeopleSurveysTab',
  components: {
    SurveyTable
  },
  mixins: [
    modelMixin,
	sessionMixin
  ],
}
</script>

<style>

</style>
