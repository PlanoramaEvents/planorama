<template>
  <b-modal
    cancel-variant="link"
    button-size="sm"
    centered
    scrollable
    v-on="$listeners"
    v-bind="$attrs"
  >
    <slot v-for="(_, name) in $slots" :name="name" :slot="name" />
    <template v-for="(_, name) in $scopedSlots" :slot="name" slot-scope="slotData"><slot :name="name" v-bind="slotData" /></template>
  </b-modal>
</template>

<script>
export default {
  name: "PlanoModal",
}
</script>

<style>

</style>
