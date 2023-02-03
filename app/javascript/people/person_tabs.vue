<template>
  <div>
    <model-loading-overlay :model="personModel">
      <b-button variant="link" @click="back" v-if="currentUserIsAdmin || currentUserIsStaff">Back</b-button>
        <person-summary></person-summary>
      <b-tabs content-class="mt-3" @activate-tab="handleTabActivation" v-if="person">
        <b-tab title="General" :active="!tab" lazy>
          <person-details></person-details>
        </b-tab>
        <b-tab title="Demographics &amp; Community" :active="tab === 'other'" lazy>
          <person-demographics></person-demographics>
        </b-tab>
        <!-- Can not make this lazy otherwise we have lock issues with the notes -->
        <b-tab title="Availability" :active="tab === 'availability'">
          <availability-and-interests
            v-if="person"
            v-model="person"
            :start_time="start_time"
            :end_time="end_time"
            :timezone="timezone"
            class="mb-5"
          ></availability-and-interests>
        </b-tab>
        <b-tab title="Session Selection" :active="tab === 'session-selection'" lazy>
          <session-selector
            v-if="person"
            v-model="person"
            defaultSortBy='sessions.title'
            :model="sessionModel"
            defaultFilter='{"op":"all","queries":[["open_for_interest", "=", true]]}'
          ></session-selector>
        </b-tab>
        <b-tab title="Session Rankings" :active="tab === 'session-ranking'" lazy>
          <session-ranker
            v-if="person"
            defaultSortBy='interest_ranking,session_assignments.updated_at'
            :defaultSortDesc="true"
            :perPage="null"
            :model="sessionAssignmentModel"
            :defaultFilter="rankedFilter"
            :person_id="person.id"
          ></session-ranker>
        </b-tab>
        <b-tab :title="liveScheduleTitle" lazy v-if="currentUserIsAdmin || currentUserIsStaff || firmSchedule" :active="tab === 'schedule'">
          <person-live-schedule></person-live-schedule>
        </b-tab>
        <b-tab title="Draft Schedule" lazy v-if="displayDraftSchedule" :active="tab === 'draft-schedule'">
          <person-draft-schedule></person-draft-schedule>
        </b-tab>
        <b-tab title="Emails" lazy v-if="currentUserIsAdmin || currentUserIsStaff" :active="tab === 'email'">
          <people-email-tab></people-email-tab>
        </b-tab>
        <b-tab title="Admin" lazy v-if="currentUserIsAdmin || currentUserIsStaff" :active="tab === 'admin'">
          <people-admin-tab></people-admin-tab>
        </b-tab>
        <b-tab title="Integrations" lazy v-if="currentUserIsAdmin" :active="tab === 'integrations'">
          <pre>{{JSON.stringify(person.integrations, undefined, 2)}}</pre>
        </b-tab>
        <b-tab title="Surveys" disabled lazy>
        </b-tab>
      </b-tabs>
    </model-loading-overlay>
  </div>
</template>

<script>
import SessionSelector from '../profile/session_selector.vue';
import SessionRanker from '../profile/session_ranker.vue';
import AvailabilityAndInterests from '../profile/availability_and_interests.vue';
import PersonDetails from '../profile/person_details.vue'
import PersonSummary from '../profile/person_summary.vue';
import PersonDemographics from '../profile/person_demographics.vue';
import PersonLiveSchedule from '@/profile/person_live_schedule.vue';
import PersonDraftSchedule from '@/profile/person_draft_schedule.vue';
import PeopleAdminTab from './people_admin_tab.vue';
import PeopleEmailTab from '@/profile/person_email_tab.vue';
import ModelLoadingOverlay from '@/components/model_loading_overlay.vue';

import { personModel } from '@/store/person.store'
import { sessionModel } from '@/store/session.store'
import { sessionAssignmentModel } from '@/store/session_assignment.store'
import personSessionMixin from '@/auth/person_session.mixin';
import settingsMixin from "@/store/settings.mixin";
import modelUtilsMixin from '@/store/model_utils.mixin';
import { scheduleWorkflowMixin, FETCH_WORKFLOWS } from '@/store/schedule_workflow';

const { DateTime } = require("luxon");

import VueRouter from 'vue-router';
import { mapActions } from 'vuex';
const { isNavigationFailure, NavigationFailureType } = VueRouter;


export default {
  name: "PeopleTabs",
  props: ['tab', 'id'],
  components: {
    PersonSummary,
    SessionSelector,
    SessionRanker,
    AvailabilityAndInterests,
    PersonDetails,
    PersonDemographics,
    ModelLoadingOverlay,
    PersonLiveSchedule,
    PersonDraftSchedule,
    PeopleAdminTab,
    PeopleEmailTab,
  },
  mixins: [
    personSessionMixin,
    settingsMixin,
    modelUtilsMixin,
    scheduleWorkflowMixin,
  ],
  data: () => ({
    personModel,
    sessionModel,
    sessionAssignmentModel,
  }),
  computed: {
    tabsArray() {
      const baseTabs = [
        'edit',
        'other',
        'availability',
        'session-selection',
        'session-ranking',
      ]
      if (this.displayDraftSchedule) {
        baseTabs.splice(5, 0, 'draft-schedule')
      }
      if (this.currentUserIsAdmin || this.currentUserIsStaff || this.firmSchedule) {
        baseTabs.splice(5, 0, 'schedule');
        baseTabs.push('email');
        baseTabs.push('admin');
      }
      if(this.currentUserIsAdmin) {
        baseTabs.push('integrations');
      }
      return baseTabs;
    },
    person() {
      return this.selected_model(personModel);
    },
    start_time() {
      if (this.currentSettings && this.currentSettings.configs) {
        let st = this.configByName('convention_start_time')
        return DateTime.fromISO(st)
      } else {
        return null
      }
    },
    end_time() {
      if (this.currentSettings && this.currentSettings.configs) {
        let et = this.configByName('convention_end_time')
        return DateTime.fromISO(et)
      } else {
        return null
      }
    },
    rankedFilter() {
      return `{"op":"all","queries":[["person_id", "=", "${this.person.id}"],["interested", "=", true]]}`
    },
    timezone() {
      let tz = this.configByName('convention_timezone')
      return tz
    }
  },
  methods: {
    ...mapActions({
      fetchScheduleWorkflows: FETCH_WORKFLOWS
    }),
    back() {
      this.$router.push('/people')
    },
    handleTabActivation(newTab, oldTab, bvEvent) {
      // change the router path to match the current tab
      // so that reloads work right
      // IF YOU ADD A TAB make sure you update the tabsArray or badness will happen
      let path = this.tabsArray[newTab];
      const pathStart = this.$route.path.split('/')[1];
      if (newTab === '0' && pathStart !== 'people') {
        path = '';
      }
      if(pathStart === 'people') {
        path += `/${this.person.id}`
      }
      this.$router.push(`/${pathStart}/${path}`).catch(error => {
        if(!isNavigationFailure(error, NavigationFailureType.duplicated)) {
          // ignore the duplicates, otherwise -
          throw error;
        }
      })
    }
  },
  mounted() {
    this.$nextTick(
      () => {
        // get id from URL if present
        let id = this.id || this.currentUser.id;
        let selectedPerson = this.selected_model(personModel);
        // don't fetch if already here... todo figure out if we
        // want to lazy fetch anyhow
        if (selectedPerson?.id !== id) {
          // tick
          this.unselect_model(personModel);
          this.fetch_model_by_id(personModel, id).then(() =>
            this.select_model(personModel, id)
          );
        }
      }
    )
    this.fetchScheduleWorkflows();
  },
  beforeRouteLeave(to, from, next) {
    if (from.path.match(/.*profile.*/) && to.path === '/people') {
      // going from profile to people, clear the selection
      this.unselect_model(personModel)
    }
    next();
  }
}
</script>

<style>

</style>
