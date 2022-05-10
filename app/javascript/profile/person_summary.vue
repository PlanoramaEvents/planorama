<template>
  <div class="container my-3" v-if="person">
    <div class="row">
      <div class="col-8">
        <h3>{{person.published_name}}</h3>
      </div>
      <div class="col-4 d-flex flex-row-reverse">
          <small>Last Login: {{formatLocaleDate(person.current_sign_in_at)}}</small>
      </div>
    </div>

      <div>
        Pronouns: <em>{{person.pronouns}}</em>
      <div>
        Willing to moderate sessions: <em>{{willing_to_moderate}}</em>
      </div>
      <div>
        Primary email: <em>{{person.primary_email.email}}</em>
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
