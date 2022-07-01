import { settingsMixin } from "@/mixins"

export const ageRestrictionMixin = {
  mixins: [ settingsMixin ],
  computed: {
    ageRestrictionOptions() {
      const opts = this.currentSettings.age_restrictions?.map(ar => ({text: ar.name, value: ar.id})) || []
      opts.push({text: 'None', value: null})
      return opts;
    }
  },
  methods: {
    ageRestrictionName(id) {
      return this.currentSettings.age_restrictions?.find(ar => ar.id === id)?.name || id;
    }
  }
}

export default ageRestrictionMixin
