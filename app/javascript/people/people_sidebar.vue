<template>
  <sidebar-vue :model="model">
    <template #header v-if="selected">
      <person-summary :readOnly="true"></person-summary>
    </template>

    <template #content v-if="selected">
      <div class="float-right d-flex justify-content-end">
        <b-button title="Edit Person" variant="primary" :to="editLink"><b-icon-pencil variant="white"></b-icon-pencil></b-button>
      </div>
      <b-tabs content-class="mt-3" nav-class="border-0" nav-wrapper-class="border-bottom">
        <b-tab title="General" active lazy>
          <person-details :readOnly="true"></person-details>
        </b-tab>
        <b-tab title="Demographics" lazy>
          <person-demographics :readOnly="true"></person-demographics>
        </b-tab>
        <b-tab title="Availability" lazy>
          <availability-flyout-tab></availability-flyout-tab>
        </b-tab>
        <b-tab :title="liveScheduleTitle" lazy v-if="currentUserIsAdmin || currentUserIsStaff || firmSchedule">
          <person-live-schedule :noSidebar="true"></person-live-schedule>
        </b-tab>
        <b-tab title="Draft Schedule" lazy v-if="displayDraftSchedule">
          <person-draft-schedule :noSidebar="true"></person-draft-schedule>
        </b-tab>
        <b-tab title="Emails" lazy v-if="currentUserIsAdmin || currentUserIsStaff">
          <person-email-tab></person-email-tab>
        </b-tab>
        <b-tab title="Admin" v-if="currentUserIsAdmin || currentUserIsStaff">
         <people-admin-tab></people-admin-tab>
        </b-tab>
        <!-- Need notes and a state change drop down -->
        <!-- These need to be done and move to the people edit/tabs screen
        <b-tab title="Surveys">
          <people-surveys-tab :model="model"></people-surveys-tab>
        </b-tab> -->
      </b-tabs>
    </template>
  </sidebar-vue>
</template>

<script>
import SidebarVue from '../components/sidebar_vue.vue';
import {personSessionMixin, modelMixin} from '@/mixins';
import Detail from './detail.vue';
import PeopleAdminTab from './people_admin_tab.vue';
import PeopleSurveysTab from './people_surveys_tab.vue';
import { scheduleWorkflowMixin } from '@/store/schedule_workflow';
import PersonDemographics from '@/profile/person_demographics.vue';
import PersonEmailTab from '@/profile/person_email_tab.vue';
import PersonDetails from '@/profile/person_details.vue';
import PersonLiveSchedule from '@/profile/person_live_schedule.vue';
import PersonDraftSchedule from '@/profile/person_draft_schedule.vue';
import PersonSummary from '@/profile/person_summary.vue';
import AvailabilityFlyoutTab from '@/profile/availability_flyout_tab.vue';

export default {
  name: 'PeopleSidebar',
  components: {
    SidebarVue,
    Detail,
    PeopleAdminTab,
    PersonDemographics,
    PersonEmailTab,
    PersonDetails,
    PersonLiveSchedule,
    PersonDraftSchedule,
    PeopleSurveysTab,
    PersonSummary,
    AvailabilityFlyoutTab,
  },
  mixins: [
    modelMixin,
    personSessionMixin,
    scheduleWorkflowMixin
  ],
  computed: {
    editLink() {
      // This needs to be a different page
      return `/people/edit/${this.selected.id}`;
    }
  }
}
</script>
