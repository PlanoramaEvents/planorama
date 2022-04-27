<template>
  <!-- Use v-b-tooltip.html to handle cases when the test is html -->
  <!-- tooltip - problem with pre -->
  <!-- overflow problem with html -->
  <span v-b-tooltip.html="{customClass: 'truncated-tooltip'}"
    :title="title"
    class="text-truncate truncated-span"
  >
    <slot>{{title}}</slot>
  </span>
</template>

<script>
export default {
  name: "TooltipOverflow",
  props: {
    title: {
      type: String,
    }
  },
}
</script>

<style lang="scss">
.truncated-tooltip {
  .tooltip-inner {
    max-width: 30rem;
  }
}
.truncated-span {
  max-width: 15rem;
  display: inline-block;
}
</style>
