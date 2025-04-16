import { SUCCESS_TOAST_TITLE, ERROR_TOAST_TITLE, nLines, ERROR_GENERIC_RECOVERABLE, ERROR_GENERIC_UNRECOVERABLE } from "@/constants/strings"
// import { errorEmail } from "@/constants/config";
import settingsMixin from "@/store/settings.mixin";

export const toastMixin = {
  mixins: [settingsMixin],
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
    // Not used anywhere ....
    // toastCallback(method, success_message) {
    //   // fuck
    //   console.debug('***** ', method)
    //   method().then(() => this.success_toast(success_message))
    //     .catch((error) => this.error_toast(error.message))
    // },
    toastSuccessFailure(success_message) {
      return {
        success: () => this.success_toast(success_message),
        failure: (error) => this.error_toast(error.message)
      }
    },
    toastPromise(promise, success_text, error_text) {
      let event_email = this.configByName('event_email');
      return new Promise((res, rej) => {
        promise.then((item) => {
          // would be better it this was the original item
          if (item == null) {
            // If the item is null then it is a NO-OP
            res(null);
          } else {
            if (item.status && item.status >= 400) {
              this.error_toast(getErrorText(event_email, item, error_text))
              rej(item)
            } else {
              this.success_toast(success_text);
              res(item);
            }
          }
        })
        .catch((error) => {
          console.error(error, error.response)
          this.error_toast(getErrorText(event_email, error.response, error_text))
          rej(error);
        })
      });
    },
  }
}

// FIX
function getErrorText(errorEmail, errorResp, errorText) {
  if (errorResp?.status === 422) {
    // if i have data, i can provide specific messages with, use that
    try {
      let errors = errorResp.data.errors.map(e => e.title).filter(e => e.match("Validation"));
      if(!errors.length) {
        return ERROR_GENERIC_RECOVERABLE(errorEmail);
      }
      return nLines(errors);
    } catch {
      // generic 422 we need to do more research about why the 422 here
      return ERROR_GENERIC_RECOVERABLE(errorEmail);
    }
  }
  // try using the provided error text
  try {
    return errorText(errorResp.status);
  } catch {
    // generic error message here
    return ERROR_GENERIC_UNRECOVERABLE(errorEmail);
  }
  
}

export default toastMixin;
