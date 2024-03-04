<template>
<div class="container-fluid scrollable">
  <h1>Preview features</h1>
  <h2>Registration Info (from Reg/clyde)</h2>
  <registration-sync-table></registration-sync-table>
  <h2>TwoSidedMultiSelect</h2>
  <div class="w-75">
  <two-sided-multi-select v-model="multiSelectValue" :options="multiSelectOptions"></two-sided-multi-select>
  <pre>
    value: {{ multiSelectValue }}
  </pre>
  </div>
</div>
</template>

<script>
// TODO: put in a component for the people matching with reg
import RegistrationSyncTable from "@/registrations/registration_sync_table.vue"
import TwoSidedMultiSelect from "@/components/two_sided_multi_select.vue";

export default {
  name: "PlayGroundComponent",
  components: {
    RegistrationSyncTable,
    TwoSidedMultiSelect
  },
  data: () => ({
    multiSelectOptions: ["one", "two", "three", "four", "five", "six"],
    multiSelectValue: ["two", "three", "six"]
  })
}
</script>

<style></style>
