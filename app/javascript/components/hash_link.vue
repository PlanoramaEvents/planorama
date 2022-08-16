<template>
  <router-link :to="base" @click.native="scrollFix(to)"><slot></slot></router-link>
</template>

<script>
import hashLinksMixin from '@/shared/hash-links.mixin';

export default {
  name: "HashLink",
  props: {
    to: {
      required: true
    },
    base: {
      default: "/"
    }
  },
  mixins: [hashLinksMixin]
}
</script>

<style>

</style>
