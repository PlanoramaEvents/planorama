<template>
<div class="container-fluid scrollable">
  <h1>Preview features</h1>
  <h2>Stepper</h2>
  <div class="w-75">
    <stepper></stepper>
  </div>
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
import TwoSidedMultiSelect from "@/components/two_sided_multi_select.vue";
import Stepper from "@/components/stepper.vue"

export default {
  name: "PlayGroundComponent",
  components: {
    TwoSidedMultiSelect,
    Stepper
  },
  data: () => ({
    multiSelectOptions: ["one", "two", "three", "four", "five", "six"],
    multiSelectValue: ["two", "three", "six"]
  })
}
</script>

<style></style>
