<template>
  <dl>
    <template v-for="(field, i) in fields">
        <dt :key="'dt-' + i">
          <slot :name="field + '-label'">
            {{PROFILE_FIELD_LABELS[field]}}
          </slot>
        </dt>
        <dd :key="'dd-' + i" class="ml-2 font-italic">
          <slot :name="field + '-val'" :value="selected[field]">
            <span v-if="selected[field] === undefined" class="text-muted">Restricted</span>
            <span v-else-if="selected[field] === true">{{  yes(field) }}</span>
            <span v-else-if="selected[field] === false">{{  no(field)  }}</span>
            <span v-else-if="selected[field] === null || selected[field].trim().length === 0" class="text-muted">{{ notSpecified(field) }}</span>
            <span v-else class="keep-format">{{selected[field]}}</span>
            <slot :name="field + '-val-end'" :value="selected[field]"></slot>
          </slot>
        </dd>
    </template>
    <slot></slot>
  </dl>
</template>

<script>
import { modelMixinNoProp } from '@/store/model.mixin'
import { personModel as model } from '@/store/person.store'
import { PROFILE_FIELD_LABELS } from '@/constants/strings';
export default {
  name: "DlPerson",
  props: {
    fields: {
      default: []
    },
    overrides: {
      default: () => {}
    },
    nullText: {
      default: "Not Specified"
    }
  },
  mixins: [
    modelMixinNoProp
  ],
  data: () => ({
    model,
    PROFILE_FIELD_LABELS
  }),
  methods: {
    getOverride(key, defaultText, field) {
      return this.overrides?.[key]?.[field] ?? defaultText;
    },
    notSpecified(field) {
      return this.getOverride('null', this.nullText, field);
    },
    yes(field) {
      return this.getOverride('true', 'Yes', field);
    },
    no(field) {
      return this.getOverride('false', 'No', field);
    }
  }
}
</script>
