<template>
  <table-vuex
    sortField='name'
    :modelType="modelType"
  >
    <template #cell(published)="{ item }">
      {{ item.public ? 'Published' : 'Closed' }}
      <small v-if="item.public">on ????</small>
    </template>
    <template #cell(updatedBy)>
      We don't track this yet.
    </template>
    <template #cell(preview)="{ item }">
      <a :href="previewLink(item)" target="_blank">Preview</a>
    </template>
    <template #cell(surveyLink)="{ item }">
      <small v-if="!item.anonymous"><i>This survey is not anonymous</i></small>
      <a v-if="item.anonymous" :href="surveyLink(item)" target="_blank">{{ surveyLink(item) }}</a>
    </template>

  </table-vuex>
</template>

<script>
import TableVuex from '../table_vuex'
import { Survey } from './survey';

export default {
  name: 'SurveyTable',
  data: () => ({
    modelType: Survey
  }),
  components: {
    TableVuex,
  },
  methods: {
    previewLink(item) {
      return `/surveys/${item.id}/preview`;
    },
    surveyLink(item) {
      // TODO add authenticity key to stop robots?
      return `/link/to/take/survey/${item.id}`;
    }
  }
}
</script>
