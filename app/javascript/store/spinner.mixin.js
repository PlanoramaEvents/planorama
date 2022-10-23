import { mapMutations } from "vuex";
import { SET_SPINNER } from "./app.store";

export const spinnerMixin = {
  methods: {
    ...mapMutations({
      setSpinner: SET_SPINNER
    }),
    showSpinner() {
      this.setSpinner(true);
    },
    hideSpinner() {
      this.setSpinner(false);
    }
  }
}

export default spinnerMixin;
