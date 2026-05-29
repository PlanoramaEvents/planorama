<template>
  <div class="mt-3">
    <b-tabs content-class="mt-3" @activate-tab="handleTabActivation">
      <b-tab title="Reports" :active="tab === 'reports'" lazy>
        <Reports ref="reports"></Reports>
      </b-tab>
      <b-tab title="Area Label Report" :active="tab === 'area-label-report'" lazy>
        <labels-by-area></labels-by-area>
      </b-tab>
    </b-tabs>
  </div>
</template>


<script>
import Reports from "@/reports/reports.vue"
import LabelsByArea from '@/reports/labels-by-area.vue';

export default {
  name: "ReportsTabs",
  components: {Reports, LabelsByArea},
  props: [
    'tab'
  ],
  methods: {
    handleTabActivation(newTab, oldTab, bvEvent) {
      let path = '';
      switch(newTab) {
        case 0:
          path = `reports`;
          break;
        case 1:
          path = `area-label-report`
          break;
        case 2:
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
}
</script>

<style scoped>

</style>
