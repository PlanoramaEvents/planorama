<template>
  <v-field
    ref="emailQuestionField"
    :name="label"
    :rules="rules"
    v-slot="{ handleChange, errors, meta }"
    v-model="localValue"
  >
    <b-form-group
      :id="groupId"
      :label="label"
      :label-for="id"
      :label-sr-only="labelSrOnly"
      :class="{'w-50': answerable}"
    >
      <b-form-input
        :id="id"
        v-model="localValue"
        :state="calcValid(meta)"
        :disabled="disabled"
        :aria-describedBy="ariaDescribedBy || groupId"
        @blur="validateField"
      ></b-form-input>
    </b-form-group>
    <error-message as="div" :name="label" v-slot="{message}">
      <div class="invalid-message">{{ message }}</div>
    </error-message>
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
    mandatory: {
      default: false
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
  data: () => ({
    internalValue: null
  }),
  emits: ["blur"],
  components: {
    VField,
    ErrorMessage
  },
  computed: {
    localValue: {
      get() {
        return this.internalValue ? this.internalValue : this.value; //?? this.internalValue;
      }, 
      set(val) {
        this.internalValue = val;
        this.$emit('input', val);
      }
    },
    groupId() {
      return `${this.id}-group`
    },
    rules() {
        // return ""
      if (this.mandatory) {
        // return { required: true }; //'required'
        return {
          required: true,
          // regex: /^[\w\-\.]+@([\w-]+\.)+[\w-]{2,}$/gm
          regex: /.+@.+\..+/
        }
      } else {
        return {
          regex: /.+@.+\..+/
        }
      }
    }
  },
  methods: {
    validateField(ev) {
      // First set the field without
      // If the question is a radio button then we do not have a ev with the value
      if ( typeof ev.target === 'undefined') {
        this.$refs.emailQuestionField.handleChange(ev, false);
      } else {
        this.$refs.emailQuestionField.handleChange(ev.target.value, false);
      }
      // Then we do the actual validation
      this.$refs.emailQuestionField.validate().then(
        (result) => {
          // If there are no errors then save the response
          if (result.errors.length == 0) {
            this.$emit('change', ev.target.value);
          }
        }
      );
    },
    calcValid(meta) {
      if (this.rules == '') {
        return null
      }

      let v = meta.dirty ? meta.valid : null
      return v;
    },
    validate() {
      let res = this.$refs['emailQuestionField'].validate();
      return res
    },
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
