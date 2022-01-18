<template>
  <span v-if="mandatory && survey.mandatory_star" class="text-danger" title="required">&nbsp;*</span>
</template>

<script>
import { surveyMixin } from '@mixins'
export default {
  name: "MandatoryStar",
  props: {
    mandatory: {
      type: Boolean,
      default: false
    }
  },
  mixins: [
    surveyMixin
  ]

}
</script>

<style>

</style>
