<template>
  <b-row>
    <b-col>
      <not-implemented v-if="disabled && bool">
        <b-form-checkbox disabled :checked="value" @input="$emit('input', $event)" @change="$emit('change', $event)">
          <slot>
            {{label}}
          </slot>
        </b-form-checkbox>
      </not-implemented>
      <b-form-checkbox v-if="!disabled && bool" :checked="value" @input="$emit('input', $event)" @change="save">
        <slot>
          {{label}}
        </slot>
      </b-form-checkbox>
      <b-form-group
        v-if="text"
        class="mt-2"
      >
        <template #label>
          <slot>{{label}}</slot>
        </template>
        <b-form-input class="w-50" :disabled="disabled" type=text :value="value" @input="$emit('input', $event)" @blur="save"></b-form-input>
      </b-form-group>
    </b-col>
  </b-row>
</template>

<script>
import NotImplemented from '../not-implemented.vue'
import surveyMixin from './survey-mixin'

export default {
  name: "SurveySetting",
  components: {
    NotImplemented
  },
  mixins: [surveyMixin],
  props: {
    value: {
      default: null
    },
    label: {
      default: null
    },
    disabled: {
      type: Boolean,
      default: false
    },
    bool: {
      type: Boolean,
      default: false
    },
    text: {
      type: Boolean,
      default: false
    },
  }
}
</script>

<style>

</style>
NotImplemented
