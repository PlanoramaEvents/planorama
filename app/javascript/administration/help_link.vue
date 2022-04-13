<template>
  <div>
    <b-button variant="link" class="text-light" v-b-modal.help-modal>Help</b-button>
    <b-modal id="help-modal" title="Help" modal-class="help-modal" ok-only>
      <p>If you need help, you can email <br />
      <a :href="mailto" target="_blank">{{email}}</a>
      <!-- <span v-if="phone"><br />or call {{phone}}</span>.-->
      </p>
    </b-modal>
  </div>
</template>

<script>
import settingsMixin from "@/store/settings.mixin";

export default {
  name: "HelpLink",
  mixins: [settingsMixin],
  computed: {
    email() {
      return this.configByName('email_reply_to_address')
    },
    phone() {
      // return this.configuration.event_phone.parameter_value || 'this event has not configured a phone yet';
      // TODO: get from settings
      return 'this event has not configured a phone yet';
    },
    mailto() {
      return `mailto:${this.email}`
    }
  }
}
</script>

<style lang="scss">
.help-modal .modal-md{
  max-width: 20rem;
}
</style>
