<template>
  <div>
    <b-form-select
      v-model="localValue"
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
  data: () => ({
    internalValue: null
  }),
  computed: {
    localValue: {
      get() {
        let v = this.internalValue ? this.internalValue : this.value;
        return v;
      }, 
      set(val) {
        this.internalValue = val;
      }
    },
  },
  methods: {
    onChange(selected) {
      this.$emit('input', selected)
    }
  }
}
</script>
