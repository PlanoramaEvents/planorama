<template>
  <icon-button icon="pencil-fill" background="none" :title="title" :disabled="disabled" disabledTooltip="You are not an admin"></icon-button>
</template>

<script>
import IconButton from './icon_button';

export default {
  name: "EditButton",
  props: {
    title: {
      default: "Edit"
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  components: {
    IconButton
  }
}
</script>

<style>

</style>
