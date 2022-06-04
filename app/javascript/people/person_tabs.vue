<template>
  <div>
    <model-loading-overlay :model="personModel">
      <b-button variant="link" @click="back">Back</b-button>
        <person-summary></person-summary>
      <b-tabs content-class="mt-3" @activate-tab="handleTabActivation" v-if="person">
        <b-tab title="General" :active="!tab" lazy>
          <person-details></person-details>
        </b-tab>
        <b-tab title="Demographics &amp; Community" :active="tab === 'other'" lazy>
          <person-demographics></person-demographics>
        </b-tab>
        <!-- Can not make this lazy otherwise we have lock issues with the notes -->
        <b-tab title="Availability &amp; Interests" :active="tab === 'availability'">
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
        <b-tab title="Admin" disabled lazy v-if="currentUserIsAdmin">
        </b-tab>
        <b-tab title="Surveys" disabled lazy>
        </b-tab>
        <b-tab title="Emails" disabled lazy>
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
import ModelLoadingOverlay from '@/components/model_loading_overlay.vue';

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
  name: "PeopleTabs",
  props: ['tab', 'id'],
  components: {
    PersonSummary,
    SessionSelector,
    SessionRanker,
    AvailabilityAndInterests,
    PersonDetails,
    PersonDemographics,
    ModelLoadingOverlay
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
    back() {
      history.back()
    },
    handleTabActivation(newTab, oldTab, bvEvent) {
      let path = '';
      const pathStart = this.$route.path.split('/')[1];
      switch(newTab) {
        case 0:
          path = pathStart === 'people' ? 'edit' : '';
          break;
        case 1:
          path = `other`;
          break;
        case 2:
          path = `availability`;
          break;
        case 3:
          path = `session-selection`;
          break;
        case 4:
          path = `session-ranking`;
          break;
      }
      // change the router path to match the current tab
      // so that reloads work right
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
    // get id from URL if present
    let id = this.id || this.currentUser.id;
    let selectedPerson = this.selected_model(personModel);
    // don't fetch if already here... todo figure out if we
    // want to lazy fetch anyhow
    if (selectedPerson?.id !== id) {
      this.unselect_model(personModel);
      this.fetch_model_by_id(personModel, id).then(() =>
        this.select_model(personModel, id)
      );
    }
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
