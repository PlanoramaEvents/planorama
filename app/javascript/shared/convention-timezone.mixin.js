import { settingsMixin } from "@/store/settings.mixin";

export const conventionTimezoneMixin = {
  mixins: [
    settingsMixin,
  ],
  computed: {
    conventionTimezone() {
      return this.currentSettings?.configs?.find(c => c.parameter === 'convention_timezone')?.parameter_value || 'UTC'
    },
  }
}

export default conventionTimezoneMixin;
