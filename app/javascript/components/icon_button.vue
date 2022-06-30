<template>
  <div class="d-inline-block">
    <span :id="spanId" class="d-inline-block" :tabindex="disabled ? 0 : -1">
      <b-button
        :size="size"
        :class="['mx-1', {'px-0': variant === 'link', 'px-2': variant === 'primary'}]"
        :variant="variant"
        v-on="$listeners"
        :id="id"
        :disabled="disabled"
        :style="style"
        v-b-tooltip.bottom
        v-bind="$attrs"
      >
        <slot v-bind="{variant: iconVariant}">
          <b-icon v-if="icon" :icon="icon" :variant="iconVariant"></b-icon>
        </slot>
      </b-button>
    </span>
    <b-tooltip :target="spanId" v-if="disabled" placement="bottom">{{disabledTooltip}}</b-tooltip>
  </div>
</template>

<script>
import { v4 as uuidv4 } from 'uuid';

export default {
  name: "IconButton",
  props: {
    background: {
      type: String,
      default: 'default'
    },
    icon: {
      type: String,
      required: false
    },
    disabledTooltip: {
      type: String,
      default: "This button is disabled"
    },
    disabled: {
      type: Boolean,
      default: false
    },
    id: {
      type: String,
      default: () => uuidv4()
    },
    size: {
      type: String,
      default: "sm"
    },
  },
  computed: {
    variant() {
      switch(this.background) {
        case "none":
          return "link";
        case "default":
          return "primary";
      }
    },
    iconVariant() {
      switch(this.variant) {
        case "link":
          return "primary";
        case "primary": {
          return undefined;
        }
      }
    },
    spanId() {
      return `${this.id}-disabled-span`;
    },
    style() {
      const styles = {}
      if (this.disabled) {
        styles.pointerEvents = 'none';
      }
      return styles;
    },
  },
}
</script>

<style>

</style>
