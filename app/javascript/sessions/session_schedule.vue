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
          <v-form as="span" class="form-row h-100" ref="durationForm" v-slot="{errors, meta }">
            <v-field name="duration" type="number" rules="min_value:10" v-slot="{ handleChange, errors }">
              <b-form-input
              type="number"
              size="sm"
              class="col-2 mr-2"
              :min="10"
              v-model="duration"
              @blur="(event) => {handleChange(event); validatedPatchSelected({duration: tempDuration}); }"
              :class="{'is-invalid': meta.dirty && !meta.valid }"
              placeholder="60"></b-form-input>
              <span class="align-self-center">minutes</span>
            </v-field>
            <error-message as="div" class="invalid-feedback" name="duration" v-slot="{message }">
              <div class="invalid-message">Sessions can't be less than 10 minutes long</div>
            </error-message>
          </v-form>
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
import { Field as VField, Form as VForm, ErrorMessage } from 'vee-validate';

export default {
  name: "SessionSchedule",
  mixins: [
    modelMixinNoProp
  ],
  components: {
    RoomPicker,
    DatetimePicker,
    VField,
    VForm,
    ErrorMessage
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
    validatedPatchSelected(data) {
      this.$refs.durationForm.validate().then(
        (result) => {
          if (result) {
            this.patchSelected(data);
          }
        }
      )
    }
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
