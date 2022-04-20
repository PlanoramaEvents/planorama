<template>
  <div class="pb-3 pt-3" v-if="person">
    <div class="d-flex flex-column">
      <h3>{{person.published_name}}</h3>
      <div>
        {{person.pronouns}}
      </div>
      <div>
        Willing to moderate sessions: {{willing_to_moderate}}
      </div>
      <div>
        {{person.primary_email.email}}
      </div>
      <div>
        <b>Last Login:</b> {{formatLocaleDate(person.current_sign_in_at)}}
      </div>
    </div>
  </div>
</template>

<script>
const { DateTime } = require("luxon");

export default {
  name: "PersonSummary",
  model: {
    prop: 'person',
    // event: 'blur'
  },
  props: {
    person: {
      type: Object,
      required: true
    }
  },
  computed: {
    willing_to_moderate() {
      return this.person.willing_to_moderate ? 'Yes' : 'No'
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
