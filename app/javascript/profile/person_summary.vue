<template>
  <div class="pb-3 pt-3">
    <div class="d-flex flex-column">
      <h3>{{person.published_name}}</h3>
      <div>
        {{person.primary_email.email}}
      </div>
      <div>
        <b>Last Login:</b> {{formatLocaleDate(person.last_sign_in_at)}}
      </div>
    </div>
  </div>
</template>

<script>
const { DateTime } = require("luxon");

export default {
  name: "PersonSummary",
  props: {
    person: {
      type: Object,
      required: true
    }
  },
  methods: {
    formatLocaleDate(date, config=DateTime.DATETIME_FULL) {
      let d = new Date(date)
      return DateTime.fromJSDate(d).toLocaleString(config)
    }
  }
}
</script>

<style>

</style>
