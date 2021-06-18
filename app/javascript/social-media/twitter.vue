<template>
  <base-social
    name="Twitter"
    :logo="logo"
    :edit="edit"
    :value="value"
    link-prefix="https://twitter.com"
  >
    <template #link="{link, value}">
      <a :href="link" target="_blank">@{{value}}</a>
    </template>
    <template #edit="{value}">
      <b-input-group prepend="@">
        <b-form-input :value="value" @change="$emit('input', $event)"></b-form-input>
      </b-input-group>
    </template>
  </base-social>
</template>

<script>
import TwitterLogo from '../images/twitter.png'
import BaseSocial from './base-social';

export default {
  name: 'Twitter',
  components: {
    BaseSocial
  },
  props: {
    edit: {
      type: Boolean,
      default: false
    },
    value: {
      type: String
    }
  },
  data: () => ({
    logo: TwitterLogo
  }),
}
</script>
