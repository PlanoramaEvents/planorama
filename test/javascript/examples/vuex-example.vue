<template>
  <div class="text-align-center">
    <input type="text" @input="actionInputIfTrue" />
    <button @click="actionClick()">Click</button>
    <p v-if="inputValue">{{inputValue}}</p>
    <p v-if="clicks">{{clicks}}</p>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';

export default {
  name: 'VuexExample',
  computed: {
    ...mapGetters(['clicks', 'inputValue'])
  },
  methods: {
    ...mapActions(['actionClick']),
    actionInputIfTrue(event) {
      const inputValue = event.target.value
      if (inputValue === "input") {
        this.$store.dispatch('actionInput', {inputValue})
      }
    }
  }
}
</script>

<style>

</style>
