<template>
  <div class="mt-3">
    <b-tabs content-class="mt-3" @activate-tab="handleTabActivation" v-if="collection.length">
      <b-tab title="Reports" :active="tab === 'reports'" lazy>
        <Reports ref="reports"></Reports>
      </b-tab>
      <b-tab title="Survey Reports" :active="tab === 'survey-reports'" lazy>
        <survey-reports :report-configs="collection"></survey-reports>
      </b-tab>
    </b-tabs>
    <div v-else>
      <Reports ref="reports"></Reports>
    </div>
  </div>
</template>


<script>
import SurveyReports from "@/reports/survey_reports.vue"
import Reports from "@/reports/reports.vue"
import { modelMixinNoProp } from '@/store/model.mixin';
import { reportConfigModel } from '@/store/survey/report_config.store'

export default {
  name: "ReportsTabs",
  components: {Reports, SurveyReports},
  props: [
    'tab'
  ],
  data() {
    return {
      model: reportConfigModel
    }
  },
  mixins : [
    modelMixinNoProp
  ],
  methods: {
    handleTabActivation(newTab, oldTab, bvEvent) {
      let path = '';
      switch(newTab) {
        case 0:
          path = `reports`;
          break;
        case 1:
          path = `survey-reports`;
          break;
      }
      this.$router.push(`/reports/${path}`).catch(error => {
        if(!isNavigationFailure(error, NavigationFailureType.duplicated)) {
          // ignore the duplicates, otherwise -
          throw error;
        }
      })
    }
  },
  mounted() {
    this.fetch()
  },
}
</script>

<style scoped>

</style>
