import {mapState, mapActions } from 'vuex';
import { GET_SETTINGS }  from "../store/settings.store";

export const settingsMixin = {
  computed: {
    ...mapState({
      currentSettings: 'settings'
    }),
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
    // fetch the current session on mount !!!
    this.fetchSettings();
  }
}

export default personSessionMixin;
