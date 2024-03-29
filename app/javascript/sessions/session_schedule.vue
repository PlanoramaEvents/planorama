<template>
  <div class="container-fluid">
    <div class="row">
      <div class="col-12">
        <b-alert variant="warning" class="alert-bright d-flex align-items-center" :show="scheduleDisabled">
          <b-icon-exclamation-triangle class="h3 mb-0 mr-3"></b-icon-exclamation-triangle>
          {{SESSION_MUST_UNDROP}}
        </b-alert>
        <h5>Space</h5>
        <room-picker :value="selected.room_id" @change="patchSelected({room_id: $event})" :disabled="scheduleDisabled"></room-picker>
        <datetime-picker :value="selected.start_time" @input="patchSelected({start_time: $event})" :disabled="scheduleDisabled"></datetime-picker>
        <b-form-group label="Duration" class="pl-2" label-cols="12" label-cols-md="1">
          <ValidationProvider v-slot="validationCtx" rules="min_value:10" class="form-row h-100">
            <b-form-input
              type="number"
              size="sm"
              class="col-2 mr-2"
              :min="10"
              v-model="duration"
              @blur="validatedPatchSelected({duration: tempDuration}, validationCtx)"
              :state="getValidationState(validationCtx)"
              placeholder="60"></b-form-input>
            <span class="align-self-center">minutes</span>
            <b-form-invalid-feedback>{{ validationCtx.errors[0] }}</b-form-invalid-feedback>
          </ValidationProvider>
        </b-form-group>
      </div>
    </div>
  </div>
</template>

<script>
import { modelMixinNoProp } from "@/mixins";
import RoomPicker from './room_picker';
import DatetimePicker from './datetime_picker';
import { SESSION_MUST_UNDROP } from "@/constants/strings";
import { ValidationProvider, extend } from 'vee-validate';
import { min_value } from 'vee-validate/dist/rules'

extend('min_value', {
  ...min_value,
  message: "Sessions can't be less than 10 minutes long"
  })

export default {
  name: "SessionSchedule",
  mixins: [
    modelMixinNoProp
  ],
  components: {
    RoomPicker,
    DatetimePicker,
    ValidationProvider
  },
  data: () => ({
    tempDuration: null,
    model: 'session',
    SESSION_MUST_UNDROP
  }),
  computed: {
    scheduleDisabled() {
      return this.selected.status === 'dropped'
    },
    duration: {
      get() {
        return this.tempDuration || this.selected.duration;
      },
      set(val) {
        this.tempDuration = val;
      }
    }
  },
  methods: {
    validatedPatchSelected(data, {dirty, valid=null}) {
      if(dirty && valid) {
        this.patchSelected(data);
      }
    },
    getValidationState({ dirty, validated, valid = null }) {
      return dirty || validated ? valid : null;
    },
  }

}
</script>

<style>

</style>
