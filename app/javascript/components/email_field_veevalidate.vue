<template>
  <v-field
    :name="label"
    type="text"
    :rules="rules"
    v-slot="{ handleChange, errors, meta }"
  >
    <b-form-group
      :id="groupId"
      :label="label"
      :label-for="id"
      :invalid-feedback="errors[0]"
      :state="!meta.dirty || meta.valid"
      :label-sr-only="labelSrOnly"
      :class="{'w-50': answerable}"
    >
      <b-form-input
        :id="id"
        :value="value"
        type="text"
        :state="!meta.dirty || meta.valid"
        :class="{'is-invalid': meta.dirty && !meta.valid }"
        :disabled="disabled"
        :aria-describedBy="ariaDescribedBy || groupId"
        @input="(event) => { handleChange(event); $emit('input', $event); }"
        @blur="(event) => { handleChange(event); $emit('blur', $event); }"
      ></b-form-input>
    </b-form-group>
    <!-- <error-message as="div" :name="label" v-slot="{message}">
      <div class="invalid-message">{{ message }}</div>
    </error-message> -->
  </v-field>    
</template>

<script>
import { Field as VField, ErrorMessage } from 'vee-validate';

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
    VField,
    ErrorMessage
  },
  computed: {
    groupId() {
      return `${this.id}-group`
    },

    rules() {
      if (this.required) {
        return {
          regex: /.+@.+\..+/,
          required: true
        }
      } else {
        return {
          regex: /^$|.+@.+\..+/
        }
      }
    }
  }
};
</script>

<style lang="css" scoped>
.invalid-message {
  width: 100%;
  margin-top: 0.25rem;
  font-size: 0.875em;
  color: #dc3545;
}
</style>
