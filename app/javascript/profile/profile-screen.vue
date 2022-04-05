<template>
  <div class="scrollable" v-if="person">
    <person-summary
      v-model="person"
    ></person-summary>
    <b-tabs content-class="mt-3">
      <b-tab title="General" active lazy>
        <person-details
          v-model="person"
        ></person-details>
      </b-tab>
      <b-tab title="Availbility & Interests" lazy>
        <availability-and-interests
          :start_time="start_time"
          :end_time="end_time"
          :timezone="timezone"
        ></availability-and-interests>
      </b-tab>
      <b-tab title="Session Selection" lazy>
        <session-selector
          defaultSortBy='title'
          :model="sessionModel"
          defaultFilter='{"op":"all","queries":[["open_for_interest", "=", true]]}'
        ></session-selector>
      </b-tab>
      <b-tab title="Session Rankings" lazy>
        <session-ranker
          defaultSortBy='interest_ranking,created_at'
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
import PersonSummary from './person_summary.vue';
import AvailabilityAndInterests from './availability_and_interests.vue';
import PersonDetails from './person_details.vue'

import { sessionModel } from '@/store/session.store'
import { sessionAssignmentModel } from '@/store/session_assignment.store'
import personSessionMixin from '../auth/person_session.mixin';

import settingsMixin from "@/store/settings.mixin";

const { DateTime } = require("luxon");

export default {
  name: "ProfileScreen",
  components: {
    SessionSelector,
    SessionRanker,
    PersonSummary,
    AvailabilityAndInterests,
    PersonDetails
  },
  mixins: [
    personSessionMixin,
    settingsMixin
  ],
  data: () => ({
    sessionModel,
    sessionAssignmentModel,
    person: null
  }),
  computed: {
    start_time() {
      if (this.currentSettings && this.currentSettings.configs) {
        return DateTime.fromISO("2022-09-01T00:00:00", {zone: this.timezone})
      } else {
        return null
      }
    },
    end_time() {
      if (this.currentSettings && this.currentSettings.configs) {
        return DateTime.fromISO("2022-09-05T11:30:00", {zone: this.timezone})
      } else {
        return null
      }
    },
    rankedFilter() {
      return `{"op":"all","queries":[["person_id", "=", "${this.currentUser.id}"],["interested", "=", true]]}`
    },
    timezone() {
      if (this.currentSettings && this.currentSettings.configs) {
        let tz = this.currentSettings.configs.find(el => el.parameter == 'convention_timezone')

        if (tz) {
          return tz.parameter_value
        } else {
          return null
        }
      } else {
        return null
      }
    }
  },
  mounted() {
    this.person = this.currentUser
  }
}
</script>

<style>

</style>
