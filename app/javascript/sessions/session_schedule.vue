<template>
  <div class="container-fluid">
    <div class="row">
      <div class="col-12">
        <h5>Space</h5>
        <!-- TODO: session can have many rooms, this needs to change (how?) -->
        <!-- <room-picker :value="selected.room_id" @change="patchSelected({room_id: $event})"></room-picker> -->
        <datetime-picker :value="selected.start_time" @input="patchSelected({start_time: $event})"></datetime-picker>
        <b-form-group label="Duration" class="pl-2" label-cols="12" label-cols-md="1">
          <div class="form-row h-100">
            <b-form-input type="number" size="sm" class="col-1 mr-2" :min="0" :value="selected.duration" @input="tempDuration = $event" @blur="patchSelected({duration: tempDuration})" placeholder="0"></b-form-input>
            <span class="align-self-center">minutes</span>
          </div>
        </b-form-group>
      </div>
    </div>
  </div>
</template>

<script>
import { modelMixinNoProp } from "@/mixins";
import RoomPicker from './room_picker';
import DatetimePicker from './datetime_picker';

export default {
  name: "SessionSchedule",
  mixins: [
    modelMixinNoProp
  ],
  components: {
    RoomPicker,
    DatetimePicker
  },
  data: () => ({
    tempDuration: null,
    model: 'session'
  }),

}
</script>

<style>

</style>
