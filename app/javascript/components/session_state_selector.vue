<template>
  <b-form-select
    v-model="selectedValue"
    @change="onChange"
    v-bind:options="currentSettings.enums.Session.status"
    :disabled='disabled'
  ></b-form-select>
</template>

<script>
import settingsMixin from "@/store/settings.mixin";

export default {
  name: 'SessionStateSelector',
  components: {
  },
  mixins: [
    settingsMixin
  ],
  props: {
    value: null,
    disabled: false
  },
  data: () =>  ({
    selectedValue: null
    // options: []
  }),
  methods: {
    onChange(arg) {
      this.$emit('input', arg)
    }
  },
  mounted() {
    this.selectedValue = this.value
  }
}
</script>

<style lang="scss">
</style>
