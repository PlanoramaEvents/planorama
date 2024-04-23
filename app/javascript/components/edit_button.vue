<template>
  <icon-button icon="pencil-fill" background="none" :title="title"></icon-button>
</template>

<script>
import IconButton from './icon_button';

export default {
  name: "EditButton",
  props: {
    title: {
      default: "Edytuj"
    }
  },
  components: {
    IconButton
  }
}
</script>

<style>

</style>
