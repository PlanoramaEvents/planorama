<template>
  <edit-modal
    v-bind="$attrs"
    v-on="$listeners"
  >
    <!-- TODO pass model data to slots -->
    <slot v-for="(_, name) in $slots" :name="name" :slot="name" />
    <template v-for="(_, name) in $scopedSlots" :slot="name" slot-scope="slotData"><slot :name="name" v-bind="slotData" /></template>
  </edit-modal>
</template>

<script>
import EditModal from '@/components/edit_modal'
export default {
  name: "PersonEditModal",
  components: {
    EditModal
  },
  props: {
    person: {
      required: true,
    },
    model: {
      required: true
    }
  }
}
</script>

<style>

</style>
