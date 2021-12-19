import { SUCCESS_TOAST_TITLE, ERROR_TOAST_TITLE } from "@/constants/strings"

export const toastMixin = {
  methods: {
    success_toast(text) {
      if (typeof text === "function") {
        text = text(this.$createElement)
      }
      this.$bvToast.toast(text, {
        variant: 'success',
        title: SUCCESS_TOAST_TITLE,
        //toaster: 'planotoaster'
      })
    },
    error_toast(text) {
      if (typeof text === "function") {
        text = text(this.$createElement)
      }
      this.$bvToast.toast(text, {
        variant: 'danger',
        title: ERROR_TOAST_TITLE,
        //toaster: 'planotoaster'
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
    toastPromise(promise, success_text, error_text) {
      return new Promise((res, rej) => {
        promise.then((item) => {
          this.success_toast(success_text);
          res(item);
        })
        .catch((error) => {
          console.error(error)
          this.error_toast(error_text(error.response?.status || 418))
          rej(error);
        })
      });
    }
  }
}

export default toastMixin;
