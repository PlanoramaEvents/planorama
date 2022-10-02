<template>
  <dl>
    <template v-for="(field, i) in fields">
        <dt :key="'dt-' + i">
          <slot :name="field + '-label'">
            {{PROFILE_FIELD_LABELS[field]}}
          </slot>
        </dt>
        <dd :key="'dd-' + i" class="ml-2">
          <slot :name="field + '-val'" :value="selected[field]">
            <span v-if="selected[field] === undefined" class="text-muted font-italic">Restricted</span>
            <span v-else-if="selected[field] === true" class="font-italic">Yes</span>
            <span v-else-if="selected[field] === false" class="font-italic">No</span>
            <span v-else-if="selected[field] === null || selected[field].trim().length === 0" class="text-muted font-italic">Not Specified</span>
            <span v-else class="keep-format font-italic">{{selected[field]}}</span>
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
    }
  },
  mixins: [
    modelMixinNoProp
  ],
  data: () => ({
    model,
    PROFILE_FIELD_LABELS
  }),
}
</script>
