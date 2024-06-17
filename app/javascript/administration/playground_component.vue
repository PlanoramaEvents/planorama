<template>
<div class="container-fluid scrollable">
  <h1>Preview features</h1>
  <h2>Registration Info (from Reg/clyde)</h2>
  <person-sync-table></person-sync-table>
</div>
</template>

<script>
import PersonSyncTable from "@/registrations/person_sync_table.vue"

export default {
  name: "PlayGroundComponent",
  components: {
    PersonSyncTable
  },
  data: () => ({
    multiSelectOptions: ["one", "two", "three", "four", "five", "six"],
    multiSelectValue: ["two", "three", "six"]
  })
}
</script>

<style></style>
