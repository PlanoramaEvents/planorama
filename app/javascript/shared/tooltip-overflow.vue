<template>
  <span v-b-tooltip="{customClass: 'truncated-tooltip', title: title}" class="text-truncate truncated-span">
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
