<template>
  <div>
    <survey-table></survey-table>
 </div>
</template>

<script>
import { modelMixin } from '@mixins'
//import sessionMixin from '../session/session.mixin';
import { getOrderedRelationships } from '../utils/jsonapi_utils'
import SurveyTable from '../surveys/survey_table';

export default {
  name: 'PeopleSurveysTab',
  components: {
    SurveyTable
  },
  mixins: [
    modelMixin
  ],
}
</script>

<style>

</style>
