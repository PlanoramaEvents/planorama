<template>
  <div>
    <b-form-group
      v-if="type !== 'checkbox'"
      :id="groupId"
      :label="label"
      :label-for="inputId"
    >
      <b-form-input
        v-if="type === 'text'"
        :id="inputId"
        :value="value"
        @input="$emit('input', $event)"
        :type="type"
        :disabled="!editable"
      ></b-form-input>
      <b-form-textarea
        v-if="type === 'textarea'"
        :id="inputId"
        :value="value"
        @input="$emit('input', $event)"
        :disabled="!editable"
        :maxlength="options.maxlength || 2000"
      ></b-form-textarea>
    </b-form-group>
    <b-form-checkbox
      v-if="type === 'checkbox'"
      :id="inputId"
      :checked="value"
      @change="$emit('input', $event)"
      :disabled="!editable"
    > {{ label }} </b-form-checkbox>
  </div>
</template>

<script>
import { mapState } from 'vuex';

export default {
  name: "ModelField",
  props: {
    label: {
      required: true,
      type: String
    },
    value: { },
    type: {
      type: String,
      default: "text"
    },
    options: {
      type: Object,
      default: {}
    }
  },
  computed: {
    inputId() {
      return `input-${this.label.toLowerCase().replace(' ', '-')}`
    },
    groupId() {
      return `${this.inputId}-group`;
    },
    ...mapState(['editable'])
  }
}
</script>
