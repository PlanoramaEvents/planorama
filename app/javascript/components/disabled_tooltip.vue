<template>
  <div class="d-inline-block">
    <span :id="spanId" class="d-inline-block" :tabindex="disabled ? 0 : -1">
      <slot></slot>
    </span>
    <b-tooltip :target="spanId" v-if="disabled" placement="bottom">{{disabledTooltip}}</b-tooltip>
  </div>
</template>

<script>
import { v4 as uuidv4 } from 'uuid';

export default {
  name: "DisabledTooltip",
  props: {
    disabledTooltip: {
      type: String,
      default: "Ten przycisk jest wyłączony"
    },
    disabled: {
      type: Boolean,
      default: false
    },
    id: {
      type: String,
      default: () => uuidv4()
    },
  },
  computed: {
    spanId() {
      return `${this.id}-disabled-span`;
    },
  },
}
</script>

<style>

</style>
