<template>
  <div>
    <div v-if="survey && survey.submissions">
      <p>Download responses: <a :href="downloadLink" :download="filename">{{filename}}</a></p>
      <p>There are <em>{{Object.values(survey.submissions).length}}</em> total responses.</p>
    </div>
    <table-vue
      ref="responses-table"
      model="submission_flat"
      defaultUrl="/survey/00000000-0000-0000-0000-000000000014/submissions/flat"
      :show-add="false"
      :show-settings="false"
      :columns="question_columns"
    >
      <template #head()="data">
        <tooltip-overflow :title="data.label">
          <div v-html="data.label" style="width: 300px;"></div>
        </tooltip-overflow>
      </template>
      <template #cell(created_at)="{ item }">
        {{new Date(item.created_at).toLocaleDateString()}}
      </template>
      <template #cell(updated_at)="{ item }">
        {{new Date(item.updated_at).toLocaleDateString()}}
      </template>
      <template #cell()="data">
        <tooltip-overflow :title="data.value">
          {{data.value}}
        </tooltip-overflow>
      </template>
    </table-vue>
  </div>
</template>

<script>
import {
  surveyMixin,
  submissionMixin,
} from '@/mixins';
import TableVue from '../components/table_vue';
import TooltipOverflow from '../shared/tooltip-overflow';
import { submissionModel, surveyModel } from '@/store/survey';
import { getOrderedRelationships } from '@/utils'
export default {
  name: 'ViewReponses',
  components: {
    TableVue,
    TooltipOverflow
  },
  mixins: [
    surveyMixin,
    submissionMixin
  ],
  // data: () => ({
  // }),
  computed: {
    downloadLink() {
      return `/survey/${this.selectedSurveyId}/submissions.xlsx`
    },
    filename() {
      return `survey_${this.selectedSurveyId}_responses.xlsx`
    },
    selectedSurveyId() {
      return this.$store.state.selected[surveyModel];
    },
    question_columns() {
      if (!this.survey || !this.survey.pages) {
        return [
          {
            key: "valx",
            label: "",
            type: "text"
          }
        ]
      }

      // TODO: we need the default of the person's name and the time
      let res = Object.values(this.survey.pages).map(
        p => Object.values(p.questions).filter(
          // Filter for question types that are questions
          // :textfield, :textbox, :singlechoice, :multiplechoice, :hr,
          // :dropdown, :address, :email, :socialmedia, :textonly
          qs => ["textbox", "textfield", "singlechoice", "multiplechoice", "dropdown", "email", "socialmedia"].includes(qs.question_type)
        ).map(
          q => (
            {
              key: `responses.${q.id}`,
              label: q.question,
              type: "text"
            }
          )
        )
      )

      return [].concat.apply([
        {
          key: "submitter",
          label: "submitter",
          type: "text"
        },
        {
          key: "created_at",
          label: "created_at"
        },
        {
          key: "updated_at",
          label: "updated_at"
        }
      ], res)
    },
    init() {
      this.$refs['responses-table'].fetchPaged()
    }
  },
  watch: {
    selectedSurveyId(newVal, oldVal) {
      if (newVal && (!oldVal || newVal !== oldVal)) {
        this.$refs['responses-table'].fetchPaged()
      }
    }
  }
}
</script>

<style>
/* This is so that the add rule in the advanced search does not go over the screen width */
div.form-group select.form-control.mr-2 {
  max-width: 500px;
}
</style>
