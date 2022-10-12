<template>
  <div class="row scrollable">
    <div class="col-12">
      <p>Welcome to Planorama, {{currentUser.published_name}}!</p>
      <p>
        You'll be using this site between now and the convention to view and manage your profile, interests and schedule.
      </p>
      <div v-if="!draftSchedule  && doneLoading">
        <p>
          To get started, click on <a href="/#/profile">Profile</a>.
        </p>
        <p>
          At this point there are 5 tabs in the profile. You will need to visit all of them.
        </p>
        <ul>
          <li>
            <b>General Tab</b>
            <ul>
              <li>
                Update your name(s), pronouns, email address, bio, and social media as needed
              </li>
              <li v-if="eventVirtual">
                If you’re not going to be attending the convention in-person, please let us know the timezone that you will be in when you attend virtually.
              </li>
            </ul>
          </li>
          <li>
            <b>Demographics &amp; Community</b>
            <ul>
              <li>Fill in your information as needed.</li>
            </ul>
          </li>
          <li>
            <b>Availability</b>
            <ul>
              <li>
                Fill in the maximum number of program items you would like to be on.
              </li>
              <li>
                Select blocks of time you will be available during the convention on the availability calendar.
              </li>
              <li>
                Select any of the specific cornerstone items you do not want to be scheduled against.
              </li>
              <li>
                Let us know any other scheduling constraints you have in the free text box.
              </li>
            </ul>
          </li>
          <li>
            <b>Session Selection</b>
            <ul>
              <li>
                Use this tab to tell us what program items you are interested in.
              </li>
              <li>
                You can filter the options for one area, look through all options or search based on text in the title and description. (Note: You need to click the search button - hitting enter does not work.)
              </li>
              <li>
                Select sessions by using the slider to the right of the description. Your selections will save automatically.
              </li>
              <li v-if="eventVirtual">
                While some items are marked or otherwise described as Virtual, many we’re not sure if they will be taking place in-person or online, so everyone should feel free to sign up for items not marked either way.
              </li>
            </ul>
          </li>
          <li>
            <b>Session Rankings</b>
            <p>
              The list of sessions you selected will display here. For each session:
              <ul>
                <li>
                  Add a ranking 1-3. The ranking system is explained on the tab. You may leave panels unranked.
                </li>
                <li>
                  Indicate moderation preference for the individual items.
                </li>
                <li>
                  Use the text box to tell us why you are a good choice for this panel and what you would contribute.
                </li>
              </ul>
            </p>
            <p>
              Please follow the additional prompt, if present.
              <ul>
                <li>
                  A sentence or two is often sufficient; essays are not required.
                </li>
                <li>
                  We have about 700 potential panelists and about two dozen staffers engaged in panelist assignments; this step helps us learn more about you in the context of a particular session.
                </li>
              </ul>
            </p>
          </li>
        </ul>
      </div>
      <div v-if="displayDraftSchedule">
        <person-schedule-display :sessions="sessions" title="Your Draft Schedule">
          <template #message>
            <router-link to="/profile/draft-schedule">Approve your draft schedule<br />or provide change requests.</router-link>
          </template>
        </person-schedule-display>
      </div>
      <div v-if="firmSchedule">
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
import { eventVirtualMixin } from '@/shared/event-virtual.mixin';

export default {
  name: "Dashboard",
  mixins: [personSessionMixin, toastMixin, scheduleWorkflowMixin, eventVirtualMixin],
  components: {
    PersonScheduleDisplay
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
