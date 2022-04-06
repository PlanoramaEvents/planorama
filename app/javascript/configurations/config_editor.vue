<template>
  <ValidationProvider
    :name="parameter.parameter_name"
    :rules="rules"
    :skipIfEmpty="true"
    v-slot="{ valid, errors }"
  >
    <b-form-group :label="parameter.parameter_name">
      <!-- TODO: We need more meaningful names, ^^^ change the label -->
      <!-- TODO: we need to change the editor type depending on the parameter.type -->
      <div v-if="parameter.parameter_type == 'Timezone'">
        <timezone-selector
          v-model="configuration.parameter_value"
          @input="onChange"
        ></timezone-selector>
      </div>
      <div v-else>
        <b-form-input
          v-model="configuration.parameter_value"
          :state="calcValid(errors,valid)"
          @change="onChange"
        ></b-form-input>
        <b-form-invalid-feedback id="inputLiveFeedback">{{ errors[0] }}</b-form-invalid-feedback>
      </div>
    </b-form-group>
  </ValidationProvider>
</template>

<script>
import modelMixin from '../store/model.mixin';
import configurationMixin from './configuration.mixin';
import { ValidationProvider } from 'vee-validate';
import TimezoneSelector from "../components/timezone_selector.vue"

export default {
  name: "ConfigEditor",
  components: {
    ValidationProvider,
    TimezoneSelector
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
      if (this.rules == '') {
        return null
      }

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
              // TODO: should we force a reload of the settings on config change?
            }
          )
        } else {
          this.configuration.parameter_value = arg
          this.save(this.configuration).then(
            (data) => {
              this.configuration = data
              // TODO: should we force a reload of the settings on config change?
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
