<template>
  <b-modal
    size="xl"
    :title="title"
    @ok='submitData'
    ref='model-form'
    @close="onClose"
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
    onClose() {
      // console.debug("**** HIDEEEEE")
      this.$emit('close')
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
