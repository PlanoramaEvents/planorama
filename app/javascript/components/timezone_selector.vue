<template>
  <div>
    <b-form-select
      v-bind:value="value"
      @change="onChange"
      :options="currentSettings.timezones"
      :disabled='disabled'
    ></b-form-select>
  </div>
</template>

<script>
import settingsMixin from "@/store/settings.mixin";

export default {
  name: 'TimezoneSelector',
  mixins: [
    settingsMixin
  ],
  props: {
    value: null,
    disabled: {
      type: Boolean,
      default: false
    },
    // TODO.... problem with fixed offset is no DST calculations at all
    // iana: { // user IANA or "fixed offset"
    //   type: Boolean,
    //   default: true
    // }
  },
  methods: {
    onChange(selected) {
      this.$emit('input', selected)
    }
  }
}
</script>
