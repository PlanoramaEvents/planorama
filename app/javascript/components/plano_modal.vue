<template>
  <b-modal
    cancel-variant="link"
    button-size="sm"
    centered
    scrollable
    v-on="$listeners"
    v-bind="$attrs"
    :id="id"
    ref="plano-modal"
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
    // When it is the default id and there is
    // more than one modal on the page show by
    // id causes problems. See interest indicator
    // as an example
    // In which case we use a ref instead as it is
    // safer
    show() {
      if (this.id != 'plano-modal') {
        this.$bvModal.show(this.id)
      } else {
        this.$refs['plano-modal'].show()
      }
    },
    hide() {
      if (this.id != 'plano-modal') {
        this.$bvModal.hide(this.id)
      } else {
        this.$refs['plano-modal'].hide()
      }
    }
  }
}
</script>

<style>

</style>
