<template>
  <ValidationProvider
    :name="parameter.parameter_name"
    :rules="rules"
    :skipIfEmpty="true"
    v-slot="{ valid, errors }"
  >
    <b-form-group :label="parameterLabel">
      <!-- TODO: We need more meaningful names, ^^^ change the label  -->
      <!-- TODO: we need to change the editor type depending on the parameter.type -->
      <div v-if="parameter.parameter_type === 'Timezone'">
        <timezone-selector
          v-model="configuration.parameter_value"
          @input="onChange"
        ></timezone-selector>
      </div>
      <div v-else-if="parameter.parameter_type === 'DateTime'">
        <b-form-datepicker
          v-model="dateval"
          @input="onChange"
        ></b-form-datepicker>
      </div>
      <div v-else-if="parameter.parameter_type === 'Boolean'">
        <b-radio-group :options="[{text: 'Yes', value: 'true'}, {text: 'No', value: 'false'}]" @input="onChange" v-model="configuration.parameter_value"></b-radio-group>
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
import settingsMixin from "@/store/settings.mixin";
import {startCase} from "lodash";
import { CONFIGURATION_LABEL_OVERRIDES } from '@/constants/strings';

const { DateTime } = require("luxon");

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
    dateval: null,
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
      }
      return '';
    },
    timezone() {
      return this.configByName('convention_timezone')
    },
    parameterLabel() {
      const param_name = this.parameter.parameter_name;
      if (param_name) {
        return CONFIGURATION_LABEL_OVERRIDES[param_name] || startCase(param_name)
      }
      return ''
    }
  },
  mixins: [
    modelMixin,
    configurationMixin,
    settingsMixin
  ],
  methods: {
    calcValid(errors, valid) {
      if (this.rules == '') {
        return null
      }

      let v = errors[0] ? false : null //(valid ? true : null);
      this.is_valid = errors[0] ? false : true
      return v;
    },
    onChange(arg) {
      let new_val = arg
      if (this.is_valid) {

        if (this.parameter.parameter_type == 'DateTime') {
          if (arg.length == 0) return
          if (this.parameter.parameter_name == "convention_end_time") {
            new_val = DateTime.fromISO(arg, {zone: this.timezone}).endOf('day').minus({ hours: 8 }).toString()
          } else {
            new_val = DateTime.fromISO(arg, {zone: this.timezone}).startOf('day').plus({ hours: 6 }).toString()
          }
        }

        if (typeof this.parameter.configuration.id === 'undefined') {
          let newconfig = {
            parameter_value: new_val,
            parameter: this.parameter.parameter_name
          }
          this.createConfiguration(newconfig).then(
            (data) => {
              this.configuration = data
            }
          )
        } else {
          this.configuration.parameter_value = new_val
          this.save(this.configuration).then(
            (data) => {
              this.configuration = data
            }
          )
        }
      }
    },
    init() {
      if (this.parameter.parameter_type == 'DateTime') {
        this.dateval = DateTime.fromISO(this.configuration.parameter_value).setZone(this.timezone).toISODate()
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
    this.init()
  }
}
</script>
