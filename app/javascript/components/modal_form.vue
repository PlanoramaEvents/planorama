<template>
  <plano-modal
    :title="title"
    ref='model-form'
  >
    <slot></slot>
    <template #modal-footer="{ ok, cancel, hide }">
      <slot name="footer" v-bind:ok="close" v-bind:cancel="onCancel"></slot>
    </template>
  </plano-modal>
</template>

<script>
import PlanoModal from './plano_modal';

export default {
  name: 'ModalForm',
  components: {
    PlanoModal
  },
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
    close() {
      this.$refs['model-form'].hide()
      this.$emit('save')
    },
    onCancel() {
      this.$refs['model-form'].hide()
      this.$emit('cancel')
    }
  }
}
</script>
