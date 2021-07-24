const toastMixin = {
  methods: {
    success_toast(text) {
      this.$bvToast.toast(text, {
        variant: 'success',
        title: 'Success',
        // toaster: 'planotoaster'
      })
    },
    error_toast(text) {
      this.$bvToast.toast(text, {
        variant: 'danger',
        title: 'Something went wrong',
        // toaster: 'planotoaster'
      })
    }
  }
}

export default toastMixin;
