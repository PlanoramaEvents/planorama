<template>
  <b-form-select
    v-model="selectedValue"
    @change="onChange"
    v-bind:options="currentSettings.enums.Person.con_state"
    :disabled='disabled'
  ></b-form-select>
  <!-- :multiple="multiple" -->
</template>

<script>
import settingsMixin from "@/store/settings.mixin";

export default {
  name: 'PersonConStateSelector',
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
