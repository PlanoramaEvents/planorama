<template>
  <ValidationProvider
    :name="parameter.parameter_name"
    :rules="rules"
    v-slot="{ valid, errors }"
  >
    <b-form-group :label="parameter.parameter_name">
    <!-- TODO: We need more meaningful names -->
      <b-form-input
        v-model="configuration.parameter_value"
        :state="calcValid(errors,valid)"
        @change="onChange"
      ></b-form-input>
      <b-form-invalid-feedback id="inputLiveFeedback">{{ errors[0] }}</b-form-invalid-feedback>
    </b-form-group>
  </ValidationProvider>
</template>

<script>
import modelMixin from '../store/model.mixin';
import configurationMixin from './configuration.mixin';
import { ValidationProvider } from 'vee-validate';

export default {
  name: "ConfigEditor",
  components: {
    ValidationProvider
  },
  props: {
    parameter: {
      type: Object,
      default: null
    },
  },
  data: () => ({
    configuration: {
      parameter_value: null
    },
    is_valid: true
  }),
  computed: {
    rules() {
      switch (this.parameter.parameter_type) {
        case 'Email' :
          return 'email'
          break;
        case 'Integer' :
          return 'numeric'
          break;
        case 'Timezone' :
          return 'timezone'
          break;
      }
      return '';
    },
  },
  mixins: [
    modelMixin,
    configurationMixin
  ],
  methods: {
    calcValid(errors, valid) {
      let v = errors[0] ? false : (valid ? true : null);
      this.is_valid = v
      return v;
    },
    onChange(arg) {
      if (this.is_valid) {
        if (typeof this.parameter.configuration.id === 'undefined') {
          let newconfig = {
            parameter_value: arg,
            parameter: this.parameter.parameter_name
          }
          this.createConfiguration(newconfig).then(
            (data) => {
              this.configuration = data
            }
          )
        } else {
          this.configuration.parameter_value = arg
          this.save(this.configuration).then(
            (data) => {
              this.configuration = data
            }
          )
        }
      }
    }
  },
  mounted() {
    if (typeof this.parameter.configuration.id !== 'undefined') {
      this.configuration = this.parameter.configuration
    } else {
      this.configuration = {
        parameter_value: null
      }
    }
  }
}
</script>
