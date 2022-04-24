<template>
  <table-vue
    @new="onNew"
    defaultSortBy='surveys.name'
    model="survey"
    :defaultFilter="defaultFilter"
    :columns="columns"
  >
    <template #cell(description)="{ item }">
      <tooltip-overflow :title="item.description">{{item.description}}</tooltip-overflow>
    </template>
    <template #cell(publishedOn)="{ item }">
      <span v-if="item.public" v-b-tooltip="{title: item.published_on}">{{new Date(item.published_on).toLocaleString()}}</span>
    </template>
    <template #cell(updated_by)="{ item }">
      <tooltip-overflow :title="item.updated_by ? item.updated_by.name : '?????'">{{item.updated_by ? item.updated_by.name : '?????'}}</tooltip-overflow>
    </template>
    <template #cell(preview)="{ item }">
      <a :href="previewLink(item)" target="_blank">Preview</a>
    </template>
    <template #cell(surveyLink)="{ item }">
      <small v-if="!item.anonymous"><i>This survey is not anonymous</i></small>
      <a v-if="item.anonymous" :href="surveyLink(item)" target="_blank">{{ surveyLink(item) }}</a>
    </template>
  </table-vue>
</template>

<script>
import { SAVE } from '../store/model.store';
import TableVue from '../components/table_vue';
import TooltipOverflow from '../shared/tooltip-overflow';
import { survey_columns as columns } from './survey';
import { mapActions } from 'vuex';
import { NEW_SURVEY } from '@/store/survey';
import { surveyMixin }from '@mixins';

export default {
  name: 'SurveyTable',
  components: {
    TableVue,
    TooltipOverflow,
  },
  props: {
    defaultFilter: String
  },
  mixins: [
    surveyMixin
  ],
  data() {
    return {
      columns
    }
  },
  methods: {
    ...mapActions({newSurvey: NEW_SURVEY}),
    previewLink(item) {
      return `/#/surveys/${item.id}/preview`;
    },
    surveyLink(item) {
      // TODO add authenticity key to stop robots?
      // This link is on the survey listing page and not accessible without login ...
      return `/#/surveys/${item.id}`;
    },
    onNew() {
      this.newSurvey().then((survey) => {
        this.$router.push({path: `/surveys/edit/${survey.id}`})
      });
    }
  }
}
</script>
