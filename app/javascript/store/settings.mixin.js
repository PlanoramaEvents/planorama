import {mapGetters, mapActions } from 'vuex';
import { GET_SETTINGS}  from "@/store/settings.store";

export const settingsMixin = {
  computed: {
    ...mapGetters(['currentSettings']),
    exclusionsMap() {
      if(this.currentSettings?.exclusions) {
        return this.currentSettings.exclusions.reduce((p, c) => ({...p, [c.id]: c.title}), {})
      }
      return {};
    }
  },
  methods: {
    ...mapActions({
      fetchSettingsInternal: GET_SETTINGS,
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
    },
    sessionRoleByName(name) {
      if (this.currentSettings.assignment_role_types) {
        let role_types = this.currentSettings.assignment_role_types
        let rt = role_types.find( c => c.name == name)

        if (rt) {
          return rt
        } else {
          return null
        }
      } else {
        return null
      }
    },
    fetchSettings() {
      this.fetchSettingsInternal();
    }
  }
}

export default settingsMixin;
