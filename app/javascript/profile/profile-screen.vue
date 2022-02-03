<template>
  <div class="scrollable">
    <profile-manage></profile-manage>
    <b-tabs content-class="mt-3">
      <b-tab title="General" active lazy>
        <availability-and-interests></availability-and-interests>
      </b-tab>
      <b-tab title="Session Selection" lazy>
        <session-selector
          defaultSortBy='title'
          :model="sessionModel"
          defaultFilter='{"op":"all","queries":[["open_for_interest", "=", true]]}'
        ></session-selector>
      </b-tab>
      <b-tab title="Session Rankings" lazy>
        <session-ranker></session-ranker>
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

export default {
  name: "ProfileScreen",
  components: {
    SessionSelector,
    SessionRanker,
    ProfileManage,
    AvailabilityAndInterests,
  },
  data: () => ({
    sessionModel
  })
}
</script>

<style>

</style>
