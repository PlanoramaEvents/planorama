<template>
  <b-overlay :show="loading" spinner-variant="primary" variant="white" opacity="1">
    <slot></slot>
  </b-overlay>
</template>

<script>
export default {
  name: "LoadingOverlay",
  props: {
    loading: {
      type: Boolean,
      default: true
    }
  }
}
</script>

<style>

</style>
