<template>
  <b-modal
    size="xl"
    :title="title"
    @ok='submitData'
    ref='model-form'
  >
    <slot></slot>
    <template #modal-footer>
      <slot name="footer"></slot>
    </template>
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
    hideModal() {
      this.$refs['model-form'].hide()
    },
    submitData(event) {
      eventBus.$emit("submit-inner-form")
    }
  }
}
</script>
