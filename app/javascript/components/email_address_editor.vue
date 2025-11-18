<template>
  <div class="d-flex flex-row w-100">
    <v-form as="div" ref="emailForm">
      <v-field name="emailfield" type="email" :rules="emailRules" v-slot="{ handleChange, errors }">
        <b-form-input
          :disabled='disabled'
          v-model.trim="value.email"
          @change="(event) => {let res = handleChange(event); emitChange(res); }"
          :class="{'is-invalid': !!errors.length }"
        ></b-form-input>
      </v-field>
      <error-message as="div" name="emailfield" v-slot="{message }">
        <div class="invalid-message">{{ message }}</div>
      </error-message>
    </v-form>
    <div style="flex-basis: 25%;">
      <div class="d-flex flex-row justify-content-end">
        <b-form-radio
          switch size="lg"
          value="true"
          @change="onCheck"
          :checked="isdefault"
          class="mt-2 pt-1 mr-5"
          :disabled='disabled'
          :name="radioGroup"
        >
        </b-form-radio>
        <b-button v-if="canDelete" @click="onDelete" size="sm" title="Delete" class="mt-2" variant="primary">
          <b-icon-trash></b-icon-trash>
        </b-button>
      </div>
    </div>
  </div>
</template>

<script>

import { Field as VField, Form as VForm, ErrorMessage } from 'vee-validate';

export default {
  name: 'EmailAddressEditor',
  components: {
    VField,
    VForm,
    ErrorMessage
  },
  props: {
    value: null,
    canDelete: {
      type: Boolean,
      default: true
    },
    disabled: {
      type: Boolean,
      default: false
    },
    radioGroup: {
      type: String,
      default: 'email-address-make-primary'
    }
  },
  computed: {
    isdefault: {
      get: function() {
        if (this.value.isdefault) {
          return this.value.isdefault
        } else {
          return null
        }
      },
      set: function(val) {
        // Vue complains if there is no set
        // but we are not setting the isDefault here anyway
        // it is an artifact of using radio buttons in a "fake" group
        // and relying on server side sync to set things
      }
    }
  },
  methods: {
    onCheck(arg) {
      this.value.isdefault = arg == 'true'
      this.emitChange()
    },
    onDelete(arg) {
      this.$emit('delete', this.value)
    },
    emitChange() {
      if (this.value.email == '') return;

      this.$refs.emailForm.validate().then(
        (result) => {
          if (result) {
            this.$emit('input', this.value)
          }
        }
      )
    }
  }
}
</script>

<script setup>
import * as yup from 'yup';

const emailRules = yup.string().email('Must be valid email');
</script>

<style lang="css" scoped>
.invalid-message {
  width: 100%;
  margin-top: 0.25rem;
  font-size: 0.875em;
  color: #dc3545;
}
</style>