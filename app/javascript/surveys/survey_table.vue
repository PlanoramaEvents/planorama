<template>
  <table-vuex
    sortField='name'
    :modelType="modelType"
  >
    <template #cell(description)="{ item }">
      <tooltip-overflow :title="item.$.welcome">{{item.$.welcome}}</tooltip-overflow>
    </template>
    <template #cell(publishedOn)="{ item }">
      <span v-if="item.public">?????</span>
    </template>
    <template #cell(lastModifiedBy)>
      Kris "Nchanter" Snyder
    </template>
    <template #cell(preview)="{ item }">
      <a :href="previewLink(item)" target="_blank">Preview</a>
    </template>
    <template #cell(surveyLink)="{ item }">
      <small v-if="!item.$.anonymous"><i>This survey is not anonymous</i></small>
      <a v-if="item.$.anonymous" :href="surveyLink(item)" target="_blank">{{ surveyLink(item) }}</a>
    </template>

  </table-vuex>
</template>

<script>
import TableVuex from '../table_vuex'
import TooltipOverflow from '../tooltip-overflow';
import { Survey } from './survey';

export default {
  name: 'SurveyTable',
  data: () => ({
    modelType: Survey
  }),
  components: {
    TableVuex,
    TooltipOverflow,
  },
  methods: {
    previewLink(item) {
      return `/surveys/${item.id}/preview`;
    },
    surveyLink(item) {
      // TODO add authenticity key to stop robots?
      return `/page/surveys#/${item.id}`;
    }
  }
}
</script>
