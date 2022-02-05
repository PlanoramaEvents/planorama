<template>
  <b-modal id="signature-modal" title="Check Sigs ....">
    <p class="my-4">
      TODO: check the sigs
    </p>
  </b-modal>
</template>


<script>
import personSessionMixin from '../auth/person_session.mixin';
import AgreementsModal from "@/components/agreements_modal";

export default {
  name: "SignAgreements",
  components: {
    AgreementsModal,
  },
  mixins: [personSessionMixin],
  methods: {
    check_signatures() {
      // TODO: @ralph deal with the login here - we have the session from the pesonSession etc

      console.debug("WE ARE GOING TO CHECK SIGS")
      this.$bvModal.show('signature-modal')
    }
  }
}
</script>

<style>

</style>
