<template>
  <validation-provider
    :rules="rules"
    :name="label"
    v-slot="{errors, dirty, validated, valid, classes}"
  >
    <b-form-group
      :label="label"
      :label-for="id"
      :id="groupId"
      class="mt-2"
    >
      <b-input-group :class="classes">
        <template #prepend v-if="prepend || $slots.prepend">
          <slot name="prepend">
            <b-input-group-text>{{prepend}}</b-input-group-text>
          </slot>
        </template>
        <b-form-input
          type="text"
          v-on="$listeners" 
          :name="label"
          :value="value"
          :disabled="disabled"
          :state="rules ? (dirty || validated ? valid ? null : false : null ) : null"
          :aria-describedby="feedbackId"
        ></b-form-input>
      </b-input-group>
      <b-form-invalid-feedback :id="feedbackId">{{errors[0]}}</b-form-invalid-feedback>
    </b-form-group>
  </validation-provider>
</template>

<script>

import { ValidationProvider } from 'vee-validate';

export default {
  name: "SimpleSocial",
  props: {
    disabled: {
      type: Boolean,
      default: false
    },
    label: {
      type: String,
      required: true
    },
    prepend: {
      type: String,
      default: null
    },
    value: {
      required: true
    },
    id: {
      type: String,
      required: false,
      default: 'social-id'
    },
    rules: {
      type: Object,
      required: false,
    }
  },
  components: {
    ValidationProvider
  },
  computed: {
    groupId() {
      return `${this.id}-group`;
    },
    feedbackId() {
      return `${this.id}-feedback`;
    }
  },
}
</script>

<style>

</style>
