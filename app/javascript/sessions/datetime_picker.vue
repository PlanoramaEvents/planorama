<template>
  <div>
    <h5>Time</h5>
    <b-form-group label="Start" class="pl-2" label-cols="12" label-cols-md="1">
      <div class="form-row">
        <b-form-select class="col-3" size="sm" :value="day" :options="dayOptionsWithNull" @change="changeDay($event)" :disabled="disabled"></b-form-select>
        <b-timepicker class="col-3 ml-2" size="sm" :value="time" @input="changeTime($event)" @hidden="$emit('input', tempDate)" :disabled="disabled"></b-timepicker>
      </div>
    </b-form-group>
  </div>
</template>

<script>
import { DateTime } from 'luxon';
import { settingsMixin } from '@/mixins';
import conventionTimezoneMixin from '@/shared/convention-timezone.mixin';

export default {
  name: "DatetimePicker",
  props:  {
    value: null,
    disabled: {
      type: Boolean,
      default: false
    }
  },
  mixins: [settingsMixin, conventionTimezoneMixin],
  data: () => ({
    tempDate: null
  }),
  computed: {
    day() {
      return this.value ? DateTime.fromISO(this.value, {zone: 'utc'}).setZone(this.conventionTimezone).toFormat('D', {locale: "en-US"}) : null;
    },
    time() {
      return this.value ? DateTime.fromISO(this.value, {zone: 'utc'}).setZone(this.conventionTimezone).toFormat('HH:mm:ss', {locale: "en-US"}) : null;
    },
    dayOptionsWithNull() {
      return [{text: "No day selected", value: null}, ...this.dayOptions];
    }
  },
  methods: {
    changeDay(newDay) {
      let retDate = this.value ? DateTime.fromISO(this.value, {zone: 'utc'}).setZone(this.conventionTimezone) : DateTime.fromObject({hour: 0, minute: 0}, {zone: this.conventionTimezone});
      if (newDay) {
        let date = DateTime.fromFormat(newDay, 'D', {locale: "en-US" }); //, {zone: this.conventionTimezone});
        retDate = retDate.set({
          year: date.year,
          month: date.month,
          day: date.day,
        })
        retDate = retDate.toUTC();
        console.log('***** retDate', retDate.toISO());
        this.$emit('input', retDate.toISO());
      }
    },
    changeTime(newTime) {
      let retDate = this.value ? DateTime.fromISO(this.value, {zone: 'utc'}) : DateTime.fromISO(this.conventionStart, {zone: 'utc'});
      if (newTime) {
        console.log('val', newTime, DateTime.fromFormat(newTime, 'HH:mm:ss'))
        let time = DateTime.fromFormat(newTime, 'HH:mm:ss', {zone: this.conventionTimezone}).toUTC();
        retDate = retDate.set({
          hour: time.hour,
          minute: time.minute,
          second: 0
        });
        console.log('retDate', retDate);
        // this.$emit('input', retDate.toISO());
        this.tempDate = retDate.toISO();
      }
    }
  }
}
</script>

<style>

</style>
