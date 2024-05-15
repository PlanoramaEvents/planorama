<template>
<div class="container-fluid scrollable">
  <h1>Registration Sync Management</h1>
  <!-- <h2>Registration Info (from Reg/clyde)</h2> -->
  <person-sync-table></person-sync-table>
</div> 
</template>

<script>
import PersonSyncTable from "@/registrations/person_sync_table.vue"

export default {
  name: "AdminRegistrations",
  components: {
    PersonSyncTable
  }
}
</script>

<style>

</style>
