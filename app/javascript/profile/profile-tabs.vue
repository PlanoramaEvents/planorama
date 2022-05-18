<template>
  <div>
    <person-summary v-if="person"
      v-model="person"
    ></person-summary>
    <b-tabs content-class="mt-3" @activate-tab="handleTabActivation" v-if="person">
      <b-tab title="General" :active="!tab" lazy>
        <person-details
          v-model="person"
          :model="personModel"
        ></person-details>
      </b-tab>
      <b-tab title="Demographics &amp; Community" :active="tab === 'other'" lazy>
        <person-demographics :selected="person"></person-demographics>
      </b-tab>
      <!-- Can not make this lazy otherwise we have lock issues with the notes -->
      <b-tab title="Availability &amp; Interests" :active="tab === 'availability'" v-if="currentSettings.configs">
        <availability-and-interests
          v-model="person"
          @input="onPersonUpdate"
          :start_time="start_time"
          :end_time="end_time"
          :timezone="timezone"
          class="mb-5"
        ></availability-and-interests>
      </b-tab>
      <b-tab title="Session Selection" :active="tab === 'session-selection'" lazy>
        <session-selector
          v-model="person"
          defaultSortBy='sessions.title'
          :model="sessionModel"
          defaultFilter='{"op":"all","queries":[["open_for_interest", "=", true]]}'
        ></session-selector>
      </b-tab>
      <b-tab title="Session Rankings" :active="tab === 'session-ranking'" lazy>
        <session-ranker
          defaultSortBy='interest_ranking,session_assignments.updated_at'
          :person_id="person.id"
          :defaultSortDesc="true"
          :perPage="null"
          :model="sessionAssignmentModel"
          :defaultFilter="rankedFilter"
        ></session-ranker>
      </b-tab>
    </b-tabs>
  </div>
</template>

<script>
import SessionSelector from './session_selector.vue';
import SessionRanker from './session_ranker.vue';
import AvailabilityAndInterests from './availability_and_interests.vue';
import PersonDetails from './person_details.vue'
import PersonSummary from './person_summary.vue';
import PersonDemographics from './person_demographics';

import { personModel } from '@/store/person.store'
import { sessionModel } from '@/store/session.store'
import { sessionAssignmentModel } from '@/store/session_assignment.store'
import personSessionMixin from '@/auth/person_session.mixin';
import settingsMixin from "@/store/settings.mixin";
import modelUtilsMixin from '@/store/model_utils.mixin';

const { DateTime } = require("luxon");

import VueRouter from 'vue-router';
const { isNavigationFailure, NavigationFailureType } = VueRouter;

export default {
  name: "ProfileTabs",
  props: ['tab', 'id'],
  components: {
    PersonSummary,
    SessionSelector,
    SessionRanker,
    AvailabilityAndInterests,
    PersonDetails,
    PersonDemographics,
  },
  mixins: [
    personSessionMixin,
    settingsMixin,
    modelUtilsMixin
  ],
  data: () => ({
    personModel,
    sessionModel,
    sessionAssignmentModel,
  }),
  computed: {
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
    onPersonUpdate(arg) {
      this.person = arg
    },
    handleTabActivation(newTab, oldTab, bvEvent) {
      let path = '';
      switch(newTab) {
        case 0:
          path = '';
          break;
        case 1:
          path = 'other';
          break;
        case 2:
          path = 'availability';
          break;
        case 3:
          path = 'session-selection';
          break;
        case 4:
          path = 'session-ranking';
          break;
      }
      // change the router path to match the current tab
      // so that reloads work right
      this.$router.push(`/profile/${path}`).catch(error => {
        if(!isNavigationFailure(error, NavigationFailureType.duplicated)) {
          // ignore the duplicates, otherwise -
          throw error;
        }
      })
    }
  },
  mounted() {
    // get id from URL if present
    let id = this.id ? this.id : this.currentUser.id
    // changed this to select the person
    this.fetch_model_by_id(personModel, id).then(
      this.select_model(personModel, id)
    )
  },
}
</script>

<style>

</style>
