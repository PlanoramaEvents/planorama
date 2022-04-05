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
    <timezone-selector v-model="person.timezone"></timezone-selector>

    <email-addresses-editor :person="person" model='email_address'></email-addresses-editor>
    <!-- {{person.email_addresses}} -->

    <br />
    {{person.bio}}
    <br />
    {{person.twelve_hour}}
    <br />
    {{person.pronouns}}
    <br />
    {{person.gender}}
    <br />
    {{person.ethnicity}}
    <br />
    {{person.opted_in}}
    <br />
    {{person.registered}}
    <br />
    <!-- TODO: get from settings .... -->
    {{person.attendance_type}}



  </div>
</template>

<script>
import TimezoneSelector from "../components/timezone_selector.vue"
import EmailAddressesEditor from "../components/email_addresses_editor.vue"

export default {
  name: "PersonDetails",
  components: {
    TimezoneSelector,
    EmailAddressesEditor
  },
  props: {
    person: {
      type: Object,
      required: true
    }
  },
  data: () =>  ({
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
