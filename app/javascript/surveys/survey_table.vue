<template>
  <table-vuex
    sortField='name'
    :modelType="modelType"
  >
    <survey-sidebar></survey-sidebar>
  </table-vuex>
</template>

<script>
import TableVuex from '../table_vuex'
import SurveySidebar from './survey_sidebar';
import { Survey } from './survey';

export default {
  name: 'SurveyTable',
  data: () => ({
    modelType: Survey
  }),
  components: {
    TableVuex,
    SurveySidebar
  },
}
</script>
