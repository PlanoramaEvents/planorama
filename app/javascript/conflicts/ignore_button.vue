<template>
  <icon-button
    title="Ignore Conflict"
    v-on="$listeners"
    v-bind="$attrs"
  >
    <template #default="{variant}">
      <b-iconstack :variant="variant">
        <b-icon-bell stacked></b-icon-bell>
        <b-icon-slash stacked variant="primary" scale="2" shift-h="2"></b-icon-slash>
        <b-icon-slash stacked variant="primary" scale="2" shift-h="-2"></b-icon-slash>
        <b-icon-slash stacked scale="2"></b-icon-slash>
      </b-iconstack>
    </template>
  </icon-button>
</template>

<script>
import IconButton from '@/components/icon_button.vue';

export default {
  name: "IgnoreButton",
  components: {
    IconButton
  }
}
</script>

<style>

</style>
