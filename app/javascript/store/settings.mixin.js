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
      let configs = this.currentSettings.configs
      let config = configs.filter( c => c.parameter == name)

      if (config) {
        return config[0].parameter_value
      } else {
        return null
      }
    }
  },
}

export default settingsMixin;
