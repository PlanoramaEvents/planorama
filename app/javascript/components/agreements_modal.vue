<template>
  <div>
    <!-- iea-modal.vue -->
    <b-modal id='agreements-modal' size="lg"
             hide-header-close no-close-on-backdrop no-close-on-esc
             @ok="okAction" @cancel="$emit('cancel', $event)"
             ok-title="I Agree" cancel-variant="link">
      <div class="agreements-title">
        <slot name="title"></slot>
      </div>
      <div class="agreements-terms">
        <slot name="terms"></slot>
      </div>
      <div>
        <footer class="modal-footer">
          <slot name="footer">
            <p>By clicking ‘Agree’ below I do hereby agree to abide by the above usage restrictions. I acknowledge that there may be personal, business, and legal implications if I use this system inappropriately.</p>
          </slot>
          <button
              type="button"
              class="btn-green"
              @click="close"
          >
            Close Modal
          </button>
        </footer>
      </div>
    </b-modal>
  </div>
</template>

<script>
export default {
  name: "AgreementsModal",
  methods: {
    close() {
      this.$emit('close');
    },
    okAction(event) {
      alert("okAction");
//      this.$emit('ok', event)
      // Got to the "home page"
//      this.$router.push('/');
      // not signing for now
      /*
      this.signIea(this.toastSuccessFailure('Information Ethics Agreement Signed')).then(() => {
        this.$emit('ok', event)
      })*/
    }
  }
}
</script>

<style scoped>
.agreements-terms {
  max-height: 50vh;
  overflow-y: auto;
}

</style>