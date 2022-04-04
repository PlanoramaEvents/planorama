<template>
  <div>
    <!-- names -->
    <!-- emails -->
    <!-- bio -->
    <!-- social media -->
    <!-- timezone -->
    <!-- 12/24 hour display pref -->

    <!-- pronouns, gender, ethnicity, opted_in -->

    <!-- registration details ?? -->
    <!-- Do we want can stream etc -->
    <timezone-selector v-model="selectedTimezone"></timezone-selector>
  </div>
</template>

<script>
import TimezoneSelector from "../components/timezone_selector.vue"

export default {
  name: "PersonDetails",
  components: {
    TimezoneSelector
  },
  props: {
    // timezone: {
    //   type: String,
    //   default: null
    // }
  },
  data: () =>  ({
    selectedTimezone: null //"Europe/Sofia"
  }),
  methods: {
    // formatDate(date, config) {
    //   return DateTime.fromISO(date).setZone(this.timezone).toLocaleString(config)
    // }
  }
}
</script>

<style lang="scss">
</style>
