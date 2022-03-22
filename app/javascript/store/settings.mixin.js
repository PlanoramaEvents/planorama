import {mapState, mapActions } from 'vuex';
import { GET_SETTINGS }  from "@/store/settings.store";

export const settingsMixin = {
  computed: {
    ...mapState({
      currentSettings: 'settings'
    }),
    // TOOD: what is connected here used for?
    connected() {
      return !!this.currentSettings.models
    }
  },
  methods: {
    ...mapActions({
      fetchSettings: GET_SETTINGS
    })
  },
  mounted() {
    // fetch the current settings on mount !!!
    this.fetchSettings();
  }
}

export default settingsMixin;
