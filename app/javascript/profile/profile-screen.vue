<template>
  <div class="scrollable">
    <profile-manage></profile-manage>
    <b-tabs content-class="mt-3">
      <b-tab title="General"  lazy>
      </b-tab>
      <b-tab title="Availbility & Interests" active lazy>
        <availability-and-interests
          :start_time="start_time"
          :end_time="end_time"
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
import ProfileManage from './profile_manage.vue';
import AvailabilityAndInterests from './availability_and_interests.vue';

import { sessionModel } from '@/store/session.store'
import { sessionAssignmentModel } from '@/store/session_assignment.store'
import personSessionMixin from '../auth/person_session.mixin';

const { DateTime } = require("luxon");

export default {
  name: "ProfileScreen",
  components: {
    SessionSelector,
    SessionRanker,
    ProfileManage,
    AvailabilityAndInterests,
  },
  mixins: [
    personSessionMixin
  ],
  data: () => ({
    sessionModel,
    sessionAssignmentModel,
    start_time: DateTime.fromISO("2022-09-01T00:00:00"),
    end_time: DateTime.fromISO("2022-09-05T11:30:00")
  }),
  computed: {
    rankedFilter() {
      return `{"op":"all","queries":[["person_id", "=", "${this.currentUser.id}"],["interested", "=", true]]}`
    }
  }
}
</script>

<style>

</style>
