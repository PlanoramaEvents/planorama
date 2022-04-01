<template>
  <div>
    <div v-for="day in days" :key="day">
      <b-row class="my-1">
        <b-col sm="4">
          <session-limit-editor
            :day="day"
            :timezone="timezone"
            model="session_limit"
          >
          </session-limit-editor>
        </b-col>
        <b-col sm="8">
          <label for="input-none">{{ formatDate(day, { weekday: 'long' }) }}</label>
        </b-col>
      </b-row>
    </div>
  </div>
</template>

<script>
import SessionLimitEditor from './session_limit_editor.vue'

const { DateTime } = require("luxon");

export default {
  name: "SessionLimits",
  components: {
    SessionLimitEditor
  },
  props: {
    days: {
      type: Array,
      required: true
    },
    timezone: {
      type: String,
      default: null
    }
  },
  methods: {
    formatDate(date, config) {
      return DateTime.fromISO(date).setZone(this.timezone).toLocaleString(config)
    }
  }
}
</script>

<style lang="scss">
</style>
