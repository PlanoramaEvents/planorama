<template>
  <b-modal
    size="xl"
    :title="title"
    @ok='submitData'
    ref='model-form'
  >
    <slot></slot>
  </b-modal>
</template>

<script>
import eventBus from '../utils/event_bus'

export default {
  name: 'ModalForm',
  props: {
    title: String
  },
  data() {
    return {
      errorMessage: null
    }
  },
  methods: {
    showModal() {
      this.$refs['model-form'].show()

    },
    submitData(event) {
      eventBus.$emit("submit-inner-form")
    }
  }
}
</script>
