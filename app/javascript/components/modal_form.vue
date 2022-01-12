<template>
  <b-modal
    size="xl"
    :title="title"
    ref='model-form'
  >
    <slot></slot>
    <template #modal-footer="{ ok, cancel, hide }">
      <slot name="footer" v-bind:ok="close" v-bind:cancel="onCancel"></slot>
    </template>
  </b-modal>
</template>

<script>

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
