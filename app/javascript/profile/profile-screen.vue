<template>
  <div class="scrollable" v-if="person">
    <person-summary
      v-model="person"
    ></person-summary>
    <b-tabs content-class="mt-3">
      <b-tab title="General" active lazy>
        <person-details
          v-model="person"
          :model="personModel"
        ></person-details>
      </b-tab>
      <b-tab title="Availability & Interests" lazy>
        <availability-and-interests
          v-model="person"
          :start_time="start_time"
          :end_time="end_time"
          :timezone="timezone"
          class="mb-5"
        ></availability-and-interests>
      </b-tab>
      <b-tab title="Session Selection" lazy>
        <session-selector
          v-model="person"
          defaultSortBy='title'
          :model="sessionModel"
          defaultFilter='{"op":"all","queries":[["open_for_interest", "=", true]]}'
        ></session-selector>
      </b-tab>
      <b-tab title="Session Rankings" lazy>
        <!-- v-model="person" -->
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

<!-- TODO: add in texts from doc  -->

<script>
import SessionSelector from './session_selector.vue';
import SessionRanker from './session_ranker.vue';
import PersonSummary from './person_summary.vue';
import AvailabilityAndInterests from './availability_and_interests.vue';
import PersonDetails from './person_details.vue'

import { personModel } from '@/store/person.store'
import { sessionModel } from '@/store/session.store'
import { sessionAssignmentModel } from '@/store/session_assignment.store'
import personSessionMixin from '../auth/person_session.mixin';

import modelUtilsMixin from "@/store/model_utils.mixin";
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
    modelUtilsMixin,
    personSessionMixin,
    settingsMixin
  ],
  data: () => ({
    personModel,
    sessionModel,
    sessionAssignmentModel,
    person: null
  }),
  computed: {
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
      return `{"op":"all","queries":[["person_id", "=", "${this.currentUser.id}"],["interested", "=", true]]}`
    },
    timezone() {
      let tz = this.configByName('convention_timezone')
      return tz
    }
  },
  mounted() {
    this.fetch_model_by_id(personModel, this.currentUser.id).then(
      (obj) => {
        this.person = obj
      }
    )
  }
}
</script>

<style>

</style>
