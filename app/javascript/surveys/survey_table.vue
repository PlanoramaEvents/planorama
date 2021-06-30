<template>
  <table-vuex
    sortField='name'
    :modelType="modelType"
    @new="onNew"
  >
    <template #cell(description)="{ item }">
      <tooltip-overflow :title="item.$.description">{{item.$.description}}</tooltip-overflow>
    </template>
    <template #cell(publishedOn)="{ item }">
      <span v-if="item.public" v-b-tooltip="{title: item.$.published_on}">{{new Date(item.$.published_on).toLocaleDateString()}}</span>
    </template>
    <template #cell(updated_by)="{ item }">
      <tooltip-overflow :title="item.$.updated_by ? item.$.updated_by.name : '?????'">{{item.$.updated_by ? item.$.updated_by.name : '?????'}}</tooltip-overflow>
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
import { SAVE } from '../model.store';
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
    },
    onNew() {
      console.log("clicked")
      // overrides parent
      let survey = new Survey({
        name: 'New Survey',
        public: false,
        survey_pages: [{
          title: 'New Survey',
          survey_questions: [{
            question: 'New Question',
            question_type: "textfield"
          }]
        }]
      });
      this.$store.dispatch(SAVE, {item: survey}).then(() => {
        this.$router.push({path: `/edit/${survey.id}`})
      });
    }
  }
}
</script>
