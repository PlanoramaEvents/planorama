<template>
  <div class="mb-3">
    <profile-manage></profile-manage>
    <b-tabs content-class="mt-3">
      <b-tab title="General" active lazy>
        <availability-and-interests></availability-and-interests>
      </b-tab>
      <b-tab title="Session Selection" lazy>
        <session-selector></session-selector>
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

export default {
  name: "ProfileScreen",
  // data: () => ({
  //   // model
  // }),
  components: {
    SessionSelector,
    SessionRanker,
    ProfileManage,
    AvailabilityAndInterests,
  }
}
</script>

<style>

</style>
