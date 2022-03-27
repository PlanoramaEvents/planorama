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
    }),
    configByName(name) {
      let configs = this.currentSettings.configs
      let config = configs.filter( c => c.parameter == name)

      if (config) {
        return config[0].parameter_value
      } else {
        return ''
      }
    }
  },
  mounted() {
    // fetch the current settings on mount !!!
    this.fetchSettings();
  }
}

export default settingsMixin;
