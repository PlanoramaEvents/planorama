<template>
  <b-tabs content-class="mt-3" @activate-tab="handleTabActivation" v-if="person">
    <b-tab title="General" :active="!tab" lazy>
      <person-details
        v-model="person"
        :model="personModel"
      ></person-details>
    </b-tab>
    <b-tab title="Availability &amp; Interests" :active="tab === 'availability'" lazy>
      <availability-and-interests
        v-model="person"
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
</template>

<script>
import SessionSelector from './session_selector.vue';
import SessionRanker from './session_ranker.vue';
import AvailabilityAndInterests from './availability_and_interests.vue';
import PersonDetails from './person_details.vue'

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
  props: ['tab'],
  components: {
    SessionSelector,
    SessionRanker,
    AvailabilityAndInterests,
    PersonDetails
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
    person: null,
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
  methods: {
    handleTabActivation(newTab, oldTab, bvEvent) {
      let path = '';
      switch(newTab) {
        case 1:
          path = 'availability';
          break;
        case 2:
          path = 'session-selection';
          break;
        case 3:
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
    this.fetch_model_by_id(personModel, this.currentUser.id).then(
      (obj) => {
        this.person = obj
      }
    )
  },
}
</script>

<style>

</style>
