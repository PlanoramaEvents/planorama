<template>
  <b-overlay :show="!selected" spinner-variant="primary" variant="white" opacity="1">
    <slot></slot>
  </b-overlay>
</template>

<script>
import { modelMixin } from '@/store/model.mixin'
export default {
  name: "ModelLoadingOverlay",
  mixins: [
    modelMixin
  ]
}
</script>

<style>

</style>
