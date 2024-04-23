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
      @focus="onEmailFocus"
      @blur="onEmailUnfocus"
      :disabled="disabled"
      :aria-describedBy="ariaDescribedBy || groupId"
      :required="required"
    ></b-form-input>
  </b-form-group>
</template>

<script>
import { NOT_AN_EMAIL, MISSING_EMAIL } from "../constants/strings";

export default {
  name: "EmailField",
  props: {
    value: {
      type: String,
    },
    validateNow: {
      type: Function,
    },
    id: {
      type: String,
      default: "input-email"
    },
    label: {
      type: String,
      default: "Adres mailowy"
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
      if (this.value?.length > 0) {
        return NOT_AN_EMAIL;
      }
      return MISSING_EMAIL;
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
      if (!this.value.trim().match(/.+@.+\..+/)) {
        if (!this.value?.trim().length && !this.required) {
          this.valid = null;
        }
        else {
          this.valid = false;
        }
      } else {
        this.valid = null;
      }
      this.$emit("validated", this.valid);
    },
    onEmailUnfocus: function (event) {
      this.validate(event);
      this.$emit("blur")
    },
    onEmailFocus: function (event) {
      this.valid = null;
      this.$emit("validated", this.valid);
    },
  },
};
</script>
