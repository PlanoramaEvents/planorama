<template>
  <div>
    <b-button v-if="!mobile" variant="link" class="text-light" v-b-modal="modalId">Help</b-button>
    <b-nav-item v-if="mobile" v-b-modal="modalId"><b-icon-question-circle class="mr-2"></b-icon-question-circle>Help</b-nav-item>
    <b-modal :id="modalId" title="Help" modal-class="help-modal" ok-only>
      <p>If you need help, you can email <br />
      <a :href="mailto" target="_blank">{{email}}</a>.
      <!-- <span v-if="phone"><br />or call {{phone}}</span>.-->
      </p>
    </b-modal>
  </div>
</template>

<script>
import settingsMixin from "@/store/settings.mixin";
import {v4 as uuidv4 } from 'uuid';

export default {
  name: "HelpLink",
  props: {
    mobile: {
      default: false
    }
  },
  mixins: [settingsMixin],
  data: () => ({
    modalId: uuidv4()
  }),
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
