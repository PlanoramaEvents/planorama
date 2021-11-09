<template>
  <div>
    <h2>Surveys</h2>
    <survey-table></survey-table>
 </div>
</template>

<script>
import { modelMixin } from '@mixins'
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
