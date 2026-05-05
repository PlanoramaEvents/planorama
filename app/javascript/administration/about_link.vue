<template>
  <div>
    <b-button variant="link" class="text-light" v-b-modal.about-modal>About</b-button>
    <plano-modal id="about-modal" title="About" modal-class="about-modal" ok-only>
      <p>Version: {{ version }}</p>
      <p><a href="https://planoramaevents.github.io/planorama">About the Planorama Team &amp; Give Feedback</a></p>
    </plano-modal>
  </div>
</template>

<script>
import PlanoModal from '@/components/plano_modal.vue';
import settingsMixin from "@/store/settings.mixin";

export default {
  name: "AboutLink",
  components: {
    PlanoModal
  },
  mixins: [settingsMixin],
  computed: {
    email() {
      return this.configByName('email_reply_to_address')
    },
    // Get the version from the runtime ENV which is set in the
    // docker file. For deployments it comes from the docker
    // file (and is VITE_PLANO_VERSION)
    version() {
      return import.meta.env.VITE_PLANO_VERSION;
    }
  }
}
</script>

<style lang="scss">
.help-modal .modal-md{
  max-width: 20rem;
}
</style>
