<template>
  <div>
    <b-button variant="link" class="text-light" v-b-modal.about-modal>About</b-button>
    <b-modal id="about-modal" title="About" modal-class="about-modal" ok-only>
      <p>Version: {{ version }}</p>
      <p><a href="https://planoramaevents.github.io/planorama">About the Planorama Team &amp; Give Feedback</a></p>
    </b-modal>
  </div>
</template>

<script>
import settingsMixin from "@/store/settings.mixin";

export default {
  name: "AboutLink",
  mixins: [settingsMixin],
  computed: {
    email() {
      return this.configByName('email_reply_to_address')
    },
    // Get the version from the runtime ENV which is set in the
    // local env OR docker file. For deployments it comes from the docker
    // file
    version() {
      return process.env.PLANO_VERSION;
    }
  }
}
</script>

<style lang="scss">
.help-modal .modal-md{
  max-width: 20rem;
}
</style>
