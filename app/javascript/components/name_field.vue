<template>
  <b-form-group
    :id="groupId"
    :label="label"
    :label-for="id"
    :invalid-feedback="invalidFeedback"
    :state="valid"
    :label-sr-only="labelSrOnly"
  >
    <b-form-input
      :id="id"
      :value="value"
      @input="$emit('input', $event)"
      type="text"
      :state="valid"
      novalidate
      @focus="onNameFocus"
      @blur="onNameUnfocus"
      :disabled="disabled"
      :aria-describedBy="ariaDescribedBy || groupId"
      :required="required"
    ></b-form-input>
  </b-form-group>
</template>

<script>
import { MISSING_NAME } from "../constants/strings";

export default {
  name: "NameField",
  props: {
    value: {
      type: String,
    },
    validateNow: {
      type: Function,
    },
    id: {
      type: String,
      default: "input-name"
    },
    label: {
      type: String,
      default: "Name"
    },
    disabled: {
      type: Boolean,
      default: false,
    },
    ariaDescribedBy: {
    },
    required: {
      default: true
    },
    labelSrOnly: {
      type: Boolean,
      default: false
    }
  },
  data: () => ({
    valid: null,
  }),
  computed: {
    invalidFeedback() {
      return MISSING_NAME;
    },
    groupId() {
      return `${this.id}-group`
    }
  },
  watch: {
    validateNow: function (val) {
      this.validate();
      val(true);
    },
  },
  methods: {
    validate: function (event) {
      if (!this.value?.trim().length && this.required) {
        this.valid = false;
      }
      else {
        this.valid = null;
      }
      this.$emit("validated", this.valid);
    },
    onNameUnfocus: function (event) {
      this.validate(event);
    },
    onNameFocus: function (event) {
      this.valid = null;
      this.$emit("validated", this.valid);
    },
  },
};
</script>
