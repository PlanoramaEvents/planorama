<template>
<div class="container-fluid scrollable">
  <h1>Funkcje podglądu</h1>
  <h2>TwoSidedMultiSelect</h2>
  <div class="w-75">
  <two-sided-multi-select v-model="multiSelectValue" :options="multiSelectOptions"></two-sided-multi-select>
  <pre>
    wartość: {{ multiSelectValue }}
  </pre>
  </div>
</div>
</template>
<script>
import TwoSidedMultiSelect from "@/components/two_sided_multi_select.vue";

export default {
  name: "PlayGroundComponent",
  components: {
    TwoSidedMultiSelect
  },
  data: () => ({
    multiSelectOptions: ["jeden", "dwa", "trzy", "cztery", "pięć", "sześć"],
    multiSelectValue: ["dwa", "trzy", "sześć"]
  })
}
</script>
<style></style>