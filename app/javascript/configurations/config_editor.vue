<template>
  <b-form-group :label="parameter.parameter_name">
    <!-- TODO: change input depending on the type of the parameter -->
    <!-- TODO: We need more meaningful names -->
    <b-form-input
      :value="configuration.parameter_value"
      @change="onChange"
    ></b-form-input>
  </b-form-group>
</template>

<script>
import modelMixin from '../store/model.mixin';
import configurationMixin from './configuration.mixin';

export default {
  name: "ConfigEditor",
  props: {
    parameter: {
      type: Object,
      default: null
    },
  },
  data: () => ({
    configuration: {
      parameter_value: null
    }
  }),
  mixins: [
    modelMixin,
    configurationMixin
  ],
  methods: {
    onChange(arg) {
      if (typeof this.parameter.configuration.id === 'undefined') {
        let newconfig = {
          parameter_value: arg,
          parameter: this.parameter.parameter_name
        }
        this.createConfiguration(newconfig)
      } else {
        this.configuration.parameter_value = arg
        this.save(this.configuration)
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
