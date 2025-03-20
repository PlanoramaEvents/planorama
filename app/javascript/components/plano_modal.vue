<template>
  <b-modal
    cancel-variant="link"
    button-size="sm"
    centered
    scrollable
    v-on="$listeners"
    v-bind="$attrs"
    :id="id"
  >
    <slot v-for="(_, name) in $slots" :name="name" />
    <template v-for="(_, name) in $slots" v-slot:[name]="slotData">
      <slot :name="name" v-bind="slotData" />
    </template>
  </b-modal>
</template>

<script>
export default {
  name: "PlanoModal",
  props: {
    id: {
      type: String,
      default: 'plano-modal'
    }
  },
  methods: {
    show() {
      this.$bvModal.show(this.id)
    },
    hide() {
      this.$bvModal.hide(this.id)
    }
  }
}
</script>

<style>

</style>
