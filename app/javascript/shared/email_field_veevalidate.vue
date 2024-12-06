<template>
  <validation-provider
    mode="eager"
    :name="label"
    :rules="{
      regex: /.+@.+\..+/,
      required: required
    }"
    v-slot="{ errors }"
  >
    <b-form-group
      :id="groupId"
      :label="label"
      :label-for="id"
      :invalid-feedback="errors[0]"
      :state="calcValid(errors)"
      :label-sr-only="labelSrOnly"
      :class="{'w-50': answerable}"
    >
      <b-form-input
        :id="id"
        :value="value"
        @input="$emit('input', $event)"
        type="text"
        :state="calcValid(errors)"
        :disabled="disabled"
        :aria-describedBy="ariaDescribedBy || groupId"
        @blur="$emit('blur', $event)"
      ></b-form-input>
    </b-form-group>
  </validation-provider>
</template>

<script>
// TODO
// import { ValidationProvider } from "vee-validate"

export default {
  name: "EmailFieldVeevalidate",
  props: {
    value: {
      type: String,
    },
    id: {
      type: String,
      default: "input-email"
    },
    label: {
      type: String,
      default: "Email address"
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
    },
    answerable: {
      type: Boolean,
      default: false
    }
  },
  components: {
    // ValidationProvider
  },
  computed: {
    groupId() {
      return `${this.id}-group`
    }
  },
  methods: {
    calcValid(errors) {
      let v = errors[0] ? false : null 
      return v;
    },
  },
};
</script>
