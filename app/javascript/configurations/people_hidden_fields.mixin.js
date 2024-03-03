import { settingsMixin } from "@/store/settings.mixin";
import { LINKED_FIELD_LABELS } from "@/constants/strings";

export const peopleHiddenFieldsMixin = {
  mixins: [
    settingsMixin
  ],
  computed: {
    peopleHideableFieldsOptions() {
      return Object.entries(this.currentSettings.attributes.Person).filter(([_, {hidable}]) => hidable ).map(([value, _]) => ({text: LINKED_FIELD_LABELS["Person"][value] || value, value}))
    },
    // can't use configByName here because that's parameter_value centric
    hiddenFields() {
      return this.currentSettings.configs?.find(c => c.parameter === 'people_hidden_fields')?.parameter_json || []
    }
  },
  methods: {
    filterFieldList(fields) {
      return fields.filter(field => !this.hiddenFields.includes(field));
    },
    isHidden(field) {
      return this.hiddenFields.includes(field);
    }
  }
}
