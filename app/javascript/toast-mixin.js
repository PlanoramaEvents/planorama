export const toastMixin = {
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
    },
    toastCallback(method, success_message) {
      method().then(() => this.success_toast(success_message))
        .catch((error) => this.error_toast(error.message))
    },
    toastSuccessFailure(success_message) {
      return {
        success: () => this.success_toast(success_message),
        failure: (error) => this.error_toast(error.message)
      }
    },
    toastPromise(promise, success_text) {
      return new Promise((res, rej) => {
        promise.then((item) => {
          this.success_toast(success_text);
          res(item);
        })
        .catch((error) => {
          console.log(error)
          this.error_toast(error.message)
          rej(error);
        })
      });
    }
  }
}

export default toastMixin;
