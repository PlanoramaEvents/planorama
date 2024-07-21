import { settingsMixin } from "@/store/settings.mixin";
import { DateTime } from 'luxon';

export const conventionTimezoneMixin = {
  mixins: [
    settingsMixin,
  ],
  computed: {
    conventionTimezone() {
      return this.currentSettings?.configs?.find(c => c.parameter === 'convention_timezone')?.parameter_value || 'UTC'
    },
    /*
    NOTE: both the start and end days needs to be in the convention timezone. Otherwise if the users
    computer's timezone is sufficiently different than the cons (like 8 or more hours) the days will
    be off by one.
    */
    conventionStart() {
      const val = this.currentSettings?.configs?.find(c => c.parameter === 'convention_start_time')?.parameter_value;
      return val ? DateTime.fromISO(val).setZone(this.conventionTimezone) : DateTime.now();
    },
    conventionEnd() {
      const val = this.currentSettings?.configs?.find(c => c.parameter === 'convention_end_time')?.parameter_value;
      return val ? DateTime.fromISO(val).setZone(this.conventionTimezone) : DateTime.now();
    },
    daysArray() {
      let numDays = Math.ceil(this.conventionEnd.diff(this.conventionStart).as('days'));
      const daysArray = [];
      for (let i = 0; i < numDays; i++) {
        daysArray.push(this.conventionStart.plus({days: i}))
      }
      return daysArray;
    },
    dayOptions() {
      return this.daysArray.map(d => ({text: d.toFormat('DDDD'), value: d.toFormat('D', {locale: "en-US" })}))
    }
  }
}

export default conventionTimezoneMixin;
