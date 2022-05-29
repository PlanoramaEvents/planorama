<template>
  <dl>
    <template v-for="(field, i) in fields">
        <dt :key="'dt-' + i">
          <slot :name="field + '-label'">
            {{PROFILE_FIELD_LABELS[field]}}
          </slot>
        </dt>
        <dd :key="'dd-' + i" class="ml-2">
          <slot :name="field + '-val'" :slot-scope="{value: selected[field]}">
            {{selected[field] | na_if_empty }}
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
