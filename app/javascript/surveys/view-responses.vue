<template>
  <div>
    <div v-if="survey">
      <p>Download responses: <a :href="downloadLink" :download="filename">{{filename}}</a></p>
      <p>There are <em>{{survey.nbr_submissions}}</em> total responses.</p>
    </div>
    <table-vue
      ref="responses-table"
      model="submission_flat"
      :defaultUrl="defaultUrl"
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
        {{new Date(item.created_at).toLocaleString()}}
      </template>
      <template #cell(updated_at)="{ item }">
        {{new Date(item.updated_at).toLocaleString()}}
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
export default {
  name: 'ViewReponses',
  props: {
    surveyId: {
      type: String,
      default: null
    }
  },
  components: {
    TableVue,
    TooltipOverflow
  },
  mixins: [
    surveyMixin,
    submissionMixin
  ],
  computed: {
    defaultUrl() {
      return `/survey/${this.surveyId}/submissions/flat`
    },
    downloadLink() {
      return `/survey/${this.surveyId}/submissions.xlsx`
    },
    filename() {
      return `survey_${this.surveyId}_responses.xlsx`
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

      let res = Object.values(this.survey.pages).map(
        p => Object.values(p.questions).filter(
          // Filter for question types that are questions
          // :textfield, :textbox, :singlechoice, :multiplechoice, :hr,
          // :dropdown, :address, :email, :socialmedia, :textonly
          qs => ["textbox", "textfield", "singlechoice", "multiplechoice", "dropdown", "email", "socialmedia", "boolean", "yesnomaybe", "attendance_type"].includes(qs.question_type)
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
          label: "Submitter",
          type: "text"
        },
        {
          key: "created_at",
          label: "Created At"
        },
        {
          key: "updated_at",
          label: "Updated At"
        }
      ], res)
    },
  },
  methods: {
    init() {
      if (!this.survey || !this.survey.pages) {
        this.selectSurvey(this.surveyId)
        this.fetchSelectedSurvey().then(() => {
          this.$refs['responses-table'].fetchPaged()
        });
      } else {
        this.$refs['responses-table'].fetchPaged()
      }
    }
  },
  mounted() {
    this.init()
  }
}
</script>

<style>
/* This is so that the add rule in the advanced search does not go over the screen width */
div.form-group select.form-control.mr-2 {
  max-width: 500px;
}
</style>
