<template>
  <v-form as="div" ref="configForm">
    <Field 
      :name="parameterLabel"
      :rules="rules"
      value=""
      v-slot="{handleChange, meta, errors}"
    >
      <b-form-group
        :label="parameterLabel"
        :label-for="id"
        :id="groupId"
      >
        <b-input-group>
          <!-- TODO: We need more meaningful names, ^^^ change the label  -->
          <!-- TODO: we need to change the editor type depending on the parameter.type -->
          <div v-if="parameter.parameter_type === 'Timezone'">
            <timezone-selector
              :name="parameter.parameter_name"
              v-model="configuration.parameter_value"
              @input="onChange"
            ></timezone-selector>
          </div>
          <div v-else-if="parameter.parameter_type === 'DateTime'">
            <b-form-datepicker
              :name="parameter.parameter_name"
              v-model="dateval"
              @input="onChange"
            ></b-form-datepicker>
          </div>
          <div v-else-if="parameter.parameter_type === 'Boolean'">
            <label>No <b-form-checkbox 
              :name="parameter.parameter_name"
              v-model="configuration.parameter_value"
              @change="(event) => { handleChange(event); onChange(event); }"
              value="true"
              unchecked-value="false"
              switch
              inline
            >Yes</b-form-checkbox></label>
          </div>
          <div v-else-if="parameter.parameter_name === 'people_hidden_fields'">
            <two-sided-multi-select
              :name="parameter.parameter_name"
              v-model="configuration.parameter_json"
              :options="peopleHideableFieldsOptions"
              not-selected-label="Visible"
              selected-label="Hidden"
              @change="(event) => { handleChange(event); onChange(event); }"
            ></two-sided-multi-select>
          </div>
          <div v-else-if="parameter.parameter_type !== 'JSON'">
            <b-form-input
              :name="parameterLabel"
              v-model="configuration.parameter_value"
              :class="{'is-invalid': meta.dirty && !meta.valid }"
              @change="(event) => { handleChange(event); onChange(event); }"
            ></b-form-input>
          </div>
        </b-input-group>
        <error-message as="div" :name="parameterLabel" v-slot="{message}">
          <div v-if="meta.dirty && !meta.valid" class="invalid-message">{{ errors[0] }}</div>
        </error-message>  
      </b-form-group>
    </Field>
  </v-form>
</template>

<script>
import modelMixin from '@/store/model.mixin';
import configurationMixin from './configuration.mixin';
import { Field, Form as VForm, ErrorMessage } from 'vee-validate';
import TimezoneSelector from "@/components/timezone_selector.vue"
import settingsMixin from "@/store/settings.mixin";
import { peopleHiddenFieldsMixin } from './people_hidden_fields.mixin';
import {startCase} from "lodash";
import { CONFIGURATION_LABEL_OVERRIDES, LINKED_FIELD_LABELS } from '@/constants/strings';
import TwoSidedMultiSelect from '@/components/two_sided_multi_select.vue';

import { DateTime } from 'luxon';

export default {
  name: "ConfigEditor",
  components: {
    VForm,
    Field,
    ErrorMessage,
    TimezoneSelector,
    TwoSidedMultiSelect,
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
          return { regex: /^$|.+@.+\..+/ }
          break;
        case 'Integer' :
          // return { integer: true }
          return { regex: /^$|^\d+$/ }
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
    },
    groupId() {
      return `${this.id}-group`;
    },
    feedbackId() {
      return `${this.id}-feedback`;
    }
  },
  mixins: [
    modelMixin,
    // TODO: add patch to the config mixin
    configurationMixin,
    settingsMixin,
    peopleHiddenFieldsMixin,
  ],
  methods: {
    onChange(arg) {
      this.$refs.configForm.validate().then(
        (result) => {
          if (result) {
            let new_val = arg
            if (this.parameter.parameter_type === 'DateTime') {
              if (arg.length == 0) return
              if (this.parameter.parameter_name === "convention_end_time") {
                new_val = DateTime.fromISO(arg, {zone: this.timezone}).endOf('day').minus({ hours: 8 }).toString()
              } else {
                new_val = DateTime.fromISO(arg, {zone: this.timezone}).startOf('day').plus({ hours: 6 }).toString()
              }
            }

            if (typeof this.parameter.configuration.id === 'undefined') {
              let newconfig = {
                parameter: this.parameter.parameter_name
              }
              if (this.parameter.parameter_type === 'JSON') {
                newconfig.parameter_json = new_val;
              } else {
                newconfig.parameter_value = new_val;
              }

              this.createConfiguration(newconfig).then(
                (data) => {
                  this.configuration = data
                }
              )
            } else if (this.parameter.parameter_type === 'JSON') {
              this.configuration.parameter_json = new_val;
              this.patchConfiguration(this.configuration, ['parameter_value']).then((res) => {
                this.configuration = res
                return;
              })
            } else {
              this.configuration.parameter_value = new_val
              this.patchConfiguration(this.configuration, ['parameter_value']).then((res) => {
                this.configuration = res
                return;
              })
            }
          }
        }
      );
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

<style lang="css" scoped>
.invalid-message {
  width: 100%;
  margin-top: 0.25rem;
  font-size: 0.875em;
  color: #dc3545;
}
</style>
