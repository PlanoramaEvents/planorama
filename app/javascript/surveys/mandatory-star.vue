<template>
  <span v-if="mandatory && survey.mandatory_star" class="text-danger" title="required">&nbsp;*</span>
</template>

<script>
import { mapState } from 'vuex'
export default {
  name: "MandatoryStar",
  props: {
    mandatory: {
      type: Boolean,
      default: false
    }
  },
  computed: mapState({
    survey: 'selected'
  })
}
</script>

<style>

</style>
