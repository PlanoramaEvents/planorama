import {mapState, mapActions } from 'vuex';
import { GET_SETTINGS }  from "@/store/settings.store";

export const settingsMixin = {
  computed: {
    ...mapState({
      currentSettings: 'settings'
    })
  },
  methods: {
    ...mapActions({
      fetchSettings: GET_SETTINGS
    }),
    configByName(name) {
      if (this.currentSettings.configs) {
        let configs = this.currentSettings.configs
        let config = configs.find( c => c.parameter == name)

        if (config) {
          return config.parameter_value
        } else {
          return null
        }
      } else {
        return null
      }
    }
  }
}

export default settingsMixin;
