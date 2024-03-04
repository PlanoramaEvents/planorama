<template>
  <loading-overlay :loading="!selected">
    <slot></slot>
  </loading-overlay>
</template>

<script>
import LoadingOverlay from './loading_overlay.vue';
import { modelMixin } from '@/store/model.mixin'
export default {
  name: "ModelLoadingOverlay",
  components: {
    LoadingOverlay
  },
  mixins: [
    modelMixin
  ]
}
</script>

<style>

</style>
