<template>
  <Field 
    :name="label"
    :rules="fieldRules"
    value=""
    v-slot="{handleChange, meta}"
  >
    <b-form-group
      :label="label"
      :label-for="id"
      :id="groupId"
      class="mt-2"
    >
      <b-input-group>
        <template #prepend v-if="prepend || $slots.prepend">
          <slot name="prepend">
            <b-input-group-text>{{prepend}}</b-input-group-text>
          </slot>
        </template>
        <b-form-input
          type="text"
          :name="label"
          v-model="val"
          @input="handleChange"
          @blur="handleChange"
          @change="emitChange" 
          :disabled="disabled"
          :aria-describedby="feedbackId"
          :class="{'is-invalid': meta.dirty && !meta.valid }"
        ></b-form-input>
      </b-input-group>
      <error-message as="div" :name="label" v-slot="{message}">
        <div v-if="meta.dirty && !meta.valid" class="invalid-message">{{ message }}</div>
      </error-message>
    </b-form-group>
  </Field>
</template>

<script>
import { Field, ErrorMessage } from 'vee-validate';

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
    validation_rules: {
      type: Object,
      required: false,
      default: null
    }
  },
  data() {
    return {
      val: null,
      fieldRules: null
    }
  },
  components: {
    Field,
    ErrorMessage
  },
  computed: {
    groupId() {
      return `${this.id}-group`;
    },
    feedbackId() {
      return `${this.id}-feedback`;
    }
  },
  methods: {
    emitChange(ev) {
      this.$emit('input', this.val)
    }
  },
  mounted() {
    this.fieldRules = this.validation_rules
    this.val = this.value
  }
}
</script>

<style lang="css" scoped>
.invalid-message {
  width: 100%;
  margin-top: 0.25rem;
  font-size: 0.875em;
  color: #dc3545;
}
</style>
