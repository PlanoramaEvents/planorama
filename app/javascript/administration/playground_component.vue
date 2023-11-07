<template>
<div class="container-fluid scrollable">
  <h1>Preview features</h1>
  <h2>Registration Info (from Reg/clyde)</h2>
  <registration-sync-table></registration-sync-table>
</div>
</template>

<script>
// TODO: put in a component for the people matching with reg
import RegistrationSyncTable from "@/registrations/registration_sync_table.vue"

export default {
  name: "PlayGroundComponent",
  components: {
    RegistrationSyncTable
  },
}
</script>

<style></style>
