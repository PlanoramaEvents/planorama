<template>
  <div class="container">
    <div v-for="day in days" :key="day">
      <b-row class="my-1">
        <b-col class="sm-2">
          <session-limit-editor
            v-model="person"
            :day="day"
            :timezone="timezone"
            model="session_limit"
          >
          </session-limit-editor>
        </b-col>
        <b-col class="sm-10">
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
  model: {
    prop: 'person'
  },
  props: {
    person: {
      type: Object,
      required: true
    },
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
      return DateTime.fromISO(date, {zone: this.timezone}).toLocaleString(config)
    }
  }
}
</script>

<style lang="scss">
</style>
