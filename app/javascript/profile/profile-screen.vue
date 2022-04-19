<template>
  <div class="scrollable">
    <person-summary v-if="person"
      v-model="person"
    ></person-summary>
    <router-view></router-view>
  </div>
</template>

<!-- TODO: add in texts from doc  -->

<script>
import PersonSummary from './person_summary.vue';

import { personModel } from '@/store/person.store'
import personSessionMixin from '../auth/person_session.mixin';

import modelUtilsMixin from "@/store/model_utils.mixin";
import settingsMixin from "@/store/settings.mixin";

export default {
  name: "ProfileScreen",
  components: {
    PersonSummary
  },
  mixins: [
    modelUtilsMixin,
    personSessionMixin,
    settingsMixin
  ],
  data: () => ({
    person: null
  }),
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
