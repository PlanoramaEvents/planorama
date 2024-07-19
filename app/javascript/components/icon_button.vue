<template>
  <div class="d-inline-block">
    <span :id="spanId" class="d-inline-block" :tabindex="disabled ? 0 : -1">
      <b-button
        :size="size"
        :class="['mx-1', {'px-0': computedVariant === 'link', 'px-2': computedVariant === 'primary'}]"
        :variant="computedVariant"
        v-on="$listeners"
        :id="id"
        :disabled="disabled"
        :style="style"
        :title="tooltip"
        v-b-tooltip.bottom
        v-bind="$attrs"
        v-b-modal="modal"
      >
        <slot v-bind="{variant: iconVariant, disabled}">
          <b-icon v-if="icon" :icon="icon" :variant="iconVariant" :class="{'text-muted': disabled && computedVariant === 'link'}"></b-icon>
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
    variant: {
      type: String,
      default: 'primary'
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
    tooltip: {
      type: String,
    },
    modal: {
      type: String,
    }
  },
  computed: {
    computedVariant() {
      switch(this.background) {
        case "none":
          return "link";
        case "default":
          return "primary";
        case "danger":
          return "danger";
      }
    },
    iconVariant() {
      switch(this.computedVariant) {
        case "link":
          return this.disabled ? undefined : this.variant;
        case "primary": 
          return undefined;
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
