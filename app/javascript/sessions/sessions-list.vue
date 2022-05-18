<template>
  <div class="mb-3">
    <session-table
      :timezone="timezone"
    ></session-table>
    <session-sidebar :model="model"></session-sidebar>
  </div>
</template>

<script>
import SessionTable from './session_table.vue';
import SessionSidebar from './session_sidebar.vue';
import { sessionModel as model } from '../store/session.store';
import settingsMixin from "@/store/settings.mixin";

export default {
  name: "SessionsList",
  data: () => ({
    model
  }),
  components: {
    SessionTable,
    SessionSidebar
  },
  mixins: [
    settingsMixin
  ],
  computed: {
    timezone() {
      let tz = this.configByName('convention_timezone')
      return tz
    }
  }
}
</script>

<style>

</style>
