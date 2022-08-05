<template>
  <!-- Use v-b-tooltip.html to handle cases when the test is html -->
  <span v-b-tooltip.html="{customClass: 'truncated-tooltip'}"
    :title="title"
        class="text-truncate truncated-span"
  >
    <slot>{{title}}</slot>
  </span>
</template>

<script>
export default {
  name: "TooltipOverflowKeepNewlines",
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
    white-space: pre-wrap;
  }
}
.truncated-span {
  max-width: 15rem;
  display: inline-block;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
}
</style>
