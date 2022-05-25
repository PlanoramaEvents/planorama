<template>
  <b-button size="sm" :class="['mx-1', {'px-0': variant === 'link', 'px-2': variant === 'primary'}]" :variant="variant" v-on="$listeners">
    <b-icon v-if="icon" :icon="icon" :variant="iconVariant"></b-icon>
  </b-button> 
</template>

<script>
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
    }
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
    }
  },
}
</script>

<style>

</style>
