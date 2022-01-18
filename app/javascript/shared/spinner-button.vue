<template>
  <b-button>
    <b-spinner label="Loading..." v-if="loading"></b-spinner>
    <slot v-if="!loading"></slot>
  </b-button>
</template>

<script>
export default {
  name: "SpinnerButton",
  props: ['loading']
}
</script>

<style>

</style>
