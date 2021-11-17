<template>
  <div v-if="value || edit" class="social-media row">
    <div class="col-1 ml-4 logo" :style="style" v-b-tooltip="name">
    </div>
    <div class="col-10" v-if="!edit">
      <slot name="link" v-bind="{link, value}">
        <a :href="link" target="_blank">{{value}}</a>
      </slot>
    </div>
    <div class="col-10" v-if="edit">
      <slot name="edit" v-bind="{value}">
        <b-form-input :value="value" @change="$emit('input', $event)"></b-form-input>
      </slot>
    </div>
  </div>
</template>

<script>
export default {
  name: 'BaseSocial',
  props: {
    name: {
      type: String,
    },
    logo: {
      type: String
    },
    edit: {
      type: Boolean,
      default: false
    },
    value: {
      type: String
    },
    linkPrefix: {
      type: String,
      required: true
    }
  },
  computed: {
    link() {
      return `${this.linkPrefix}/${this.value}`
    },
    style() {
      console.debug(this.logo)
      return this.logo ? `--logo-image: url(${this.logo.replace('\\', '')});` : '';

    }
  }
}
</script>

<style lang="scss" scoped>
.logo {
  background-image: var(--logo-image);
  background-repeat: no-repeat;
  background-size: contain;
}
</style>
