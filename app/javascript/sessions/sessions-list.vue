<template>
  <div class="mb-3">
    <session-table></session-table>
    <session-sidebar :model="model"></session-sidebar>
  </div>
</template>

<script>
import SessionTable from './session_table.vue';
import SessionSidebar from './session_sidebar.vue';
import { sessionModel as model } from '../store/session.store';

export default {
  name: "SessionsList",
  data: () => ({
    model
  }),
  components: {
    SessionTable,
    SessionSidebar
  }
}
</script>

<style>

</style>
