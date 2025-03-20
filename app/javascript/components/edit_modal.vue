<template>
  <plano-modal
    no-close-on-backdrop
    :ok-title="okTitle"
    v-on="$listeners"
    v-bind="$attrs"
  >
    <slot v-for="(_, name) in $slots" :name="name" />
    <template v-for="(_, name) in $slots" v-slot:[name]="slotData">
      <slot :name="name" v-bind="slotData" />
    </template>
  </plano-modal>
</template>

<script>
import PlanoModal from './plano_modal';

export default {
  name: "EditModal",
  props: {
    okTitle: {
      type: String,
      default: 'Save'
    }
  },
  components: {
    PlanoModal
  },
}
</script>

<style>

</style>
