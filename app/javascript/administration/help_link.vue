<template>
  <div>
    <b-button variant="link" class="text-light" v-b-modal.help-modal>Help</b-button>
    <b-modal id="help-modal" title="Help" modal-class="help-modal" ok-only>
      <p>If you need help, you can email <br />
      <a :href="mailto" target="_blank">{{email}}</a><span v-if="phone"><br />or call {{phone}}</span>.</p>
    </b-modal>
  </div>
</template>

<script>
import { mapState } from 'vuex'
export default {
  name: "HelpLink",
  computed: {
    // ...mapState('admin/configuration', {
    //   configuration: 'collection',
    // }),
    email() {
      // return this.configuration.event_email.parameter_value || 'this event has not configured an email yet';
      return 'this event has not configured an email yet';
    },
    phone() {
      // return this.configuration.event_phone.parameter_value || 'this event has not configured a phone yet';
      return 'this event has not configured a phone yet';
    },
    mailto() {
      return `mailto:${this.email}`
    }
  },
  mounted() {
    // This does not deal with 401 well
    // this.configuration.fetch().catch((error) => {})
  }
}
</script>

<style lang="scss">
.help-modal .modal-md{
  max-width: 20rem;
}
</style>
