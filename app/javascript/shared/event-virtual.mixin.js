import { settingsMixin } from "@/mixins";

export const eventVirtualMixin = {
  mixins: [
    settingsMixin,
  ],
  computed: {
    eventVirtual() {
      return this.configByName('event_virtual') !== "false"
    }
  }
}
