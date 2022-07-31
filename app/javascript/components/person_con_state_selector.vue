<template>
  <b-form-select
    :options="options"
    v-bind="$attrs"
    v-on="$listeners"
  ></b-form-select>
</template>

<script>
import settingsMixin from "@/store/settings.mixin";
import { PERSON_CON_STATE } from '@/constants/strings';

export default {
  name: 'PersonConStateSelector',
  components: {
  },
  mixins: [
    settingsMixin
  ],
  computed: {
    options() {
      return this.currentSettings.enums.Person.con_state.map(value => ({text: PERSON_CON_STATE[value], value}))
    }
  },
}
</script>

<style lang="scss">
</style>
