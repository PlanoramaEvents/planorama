<template>
  <div class="scrollable">
    <survey-table></survey-table>
    <survey-sidebar></survey-sidebar>
  </div>
</template>

<script>
import SurveyTable from './survey_table';
import SurveySidebar from './survey_sidebar';

export default {
  name:"SurveyList",
  components: {
    SurveyTable,
    SurveySidebar
  }
}
</script>
