<template>
    <b-input-group>
      <b-input-group-prepend>
        <b-input-group-text>
          <b-icon icon="search" />
        </b-input-group-text>
      </b-input-group-prepend>

      <b-form-input
        type="text"
        v-model="value"
        debounce="500"
      ></b-form-input>

      <b-input-group-append>
        <b-input-group-text>
          <b-icon
            icon="x"
            @click="onSearchClear"
          />
        </b-input-group-text>
      </b-input-group-append>
    </b-input-group>
</template>

<script>
export default {
  name: 'SearchVue',
  data() {
    return {
      value: null
    }
  },
  computed: {
    filter() {
      // TODO: revise this when we have finialized filter/search param
      return {
          rules: [
            ["all", "like", this.value]
          ]
      }
    }
  },
  watch: {
    value (newval, oldval) {
      if (newval != oldval) {
        this.$emit('change', this.filter)
      }
    }
  },
  methods: {
    onSearchClear: function (event) {
      this.value = null
      this.$emit('change', null)
    }
  }
}
</script>

<style lang="scss" scoped>
</style>
