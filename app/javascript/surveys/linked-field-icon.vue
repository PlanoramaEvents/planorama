<template>
  <b-icon-link45deg variant="info" v-if="linked_field"></b-icon-link45deg>
</template>

<script>
import { SURVEY_LINKED_FIELD } from "@/constants/strings"

export default {
  name: "LinkedFieldIcon",
  data: () => ({
    SURVEY_LINKED_FIELD
  }),
  props: {
    linked_field: {
      type: Boolean,
      default: false
    }
  }
}
</script>

<style>

</style>
