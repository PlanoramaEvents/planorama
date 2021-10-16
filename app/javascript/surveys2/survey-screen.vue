<template>
<div>
  <table-vue sortField="name" model="survey" :columns="columns"></table-vue>
  <sidebar-vue model="survey"></sidebar-vue>
</div>
  
</template>

<script>
import SidebarVue from '../components/sidebar_vue';
import TableVue from '../components/table_vue';
import { survey_columns as columns } from '../surveys/survey'

export default {
  name: 'SurveyScreen',
  components: {
    SidebarVue,
    TableVue
  },
  data: () => ({
    columns,
  }),
}
</script>

<style>

</style>
