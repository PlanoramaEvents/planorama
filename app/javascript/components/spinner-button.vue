<template>
  <b-button
    v-on="$listeners"
    v-bind="$attrs"
  >
    <b-spinner label="Loading..." v-if="loading" small></b-spinner>
    <slot v-if="!loading || showButtonTextWhileLoading"></slot>
  </b-button>
</template>

<script>
export default {
  name: "SpinnerButton",
  props: {
    loading: {
      default: false,
    },
    showButtonTextWhileLoading: {
      default: false
    }
  }
}
</script>

<style>

</style>
