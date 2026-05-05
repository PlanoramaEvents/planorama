<template>
  <div class="row scrollable">
    <div class="col-12">
      <p>Welcome to Planorama, {{currentUser.published_name}}!</p>
      <p>
        You'll be using this site between now and the convention to view and manage your profile, interests and schedule.
      </p>
      <div v-if="!draftSchedule  && doneLoading">
        <page-content-display name="dashboard-default"></page-content-display>
      </div>
      <div v-if="displayDraftSchedule">
        <page-content-display name="dashboard-schedule"></page-content-display>
        <person-schedule-display :sessions="sessions" title="Your Draft Schedule">
          <template #message>
            <router-link to="/profile/draft-schedule">Approve your draft schedule<br />or provide change requests.</router-link>
          </template>
        </person-schedule-display>
      </div>
      <div v-if="firmSchedule">
        <page-content-display name="dashboard-schedule"></page-content-display>
        <person-schedule-display :sessions="sessions" title="Your Schedule">
          <template #message>
            <router-link to="/profile/schedule">Approve your schedule<br />or provide change requests.</router-link>
          </template>
        </person-schedule-display>
      </div>
    </div>
  </div>
</template>

<script>
import { personSessionMixin, toastMixin} from '@/mixins';
import { mapActions } from 'vuex'; 
import { FETCH_WORKFLOWS, scheduleWorkflowMixin } from '@/store/schedule_workflow';
import PersonScheduleDisplay from '@/profile/person_schedule_display.vue';
import { eventVirtualMixin } from '@/mixins/event-virtual.mixin';
import PageContentDisplay from '@/page-content/page_content_display.vue'

export default {
  name: "Dashboard",
  mixins: [personSessionMixin, toastMixin, scheduleWorkflowMixin, eventVirtualMixin],
  components: {
    PersonScheduleDisplay,
    PageContentDisplay
  },
  methods: {
    ...mapActions({
      fetchScheduleWorkflows: FETCH_WORKFLOWS,
      get: 'jv/get'
    }),
  },
  data: () => ({
    doneLoading: false,
    sessions: {},
  }),
  mounted() {
    // stopgap for not loading the session workflows earlier when logged in 
    this.fetchScheduleWorkflows().then(_ => {
      this.doneLoading = true
      if(this.draftSchedule) {
        let endpoint = this.displayDraftSchedule ? 'snapshot_schedule' : 'live_sessions'
        this.get(`/person/${this.currentUser.id}/${endpoint}`).then(data => {
          const {_jv, ...filtered_data} = data;
          this.sessions = filtered_data;
        });
      }
    });
  }
}
</script>

<style>

</style>
