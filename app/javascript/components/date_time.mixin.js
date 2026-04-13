import { conventionTimezoneMixin } from "@/mixins";

import { DateTime } from 'luxon';

export const dateTimeMixin = {
  mixins: [
    conventionTimezoneMixin
  ],
  props: {
    timezone: {
      type: String,
      default: null
    }
  },
  computed: {
    tz() {
      return this.timezone || this.conventionTimezone;
    }
  },
  methods: {
    formatLocaleDate(date) {
      let res = DateTime.fromISO(date, {zone: this.tz}).toLocaleString(DateTime.DATETIME_FULL)
      return res
    },
    // Take a Javascript datetime and format it as a time string in the local timezone
    formatLocaleJsDate(date) {
      let res = DateTime.fromJSDate(date).toLocaleString(DateTime.TIME_SIMPLE)
      return res
    },
    // Take a datetime and format it as a time string in the local timezone
    // was formatLxDate
    formatDatetime(date) {
      let res = date.toLocaleString(DateTime.TIME_SIMPLE)
      return res
    },
    // format the datetime as a string using the provided config
    // config conforms to the JS standard for datetime formatting
    formatDate(date, config) {
      // TODO: use the users locale or browsers locale here
      return date.toLocaleString('en-US',config)
    },
    // Add given amount of minutes to the given JS datetime
    addMinutes(datetime, mins) {
      var dt = DateTime.fromJSDate(datetime)
      return dt.plus({minutes: mins})
    },
    // Take the datetime used in the UI and treat it as a datetime in the
    // timezone. i.e. ignofe the browser's default TZ if we have a preferred one
    // and treat all datetimes as if they are in the preferred TZ.
    uiDateToTZDate(date) {
      return DateTime.fromObject({
        year: date.getFullYear(),
        month: date.getMonth() +1,
        day: date.getDate(),
        hour: date.getHours(),
        minute: date.getMinutes()},
        { zone: this.tz }
      )
    }
  }
}

export default dateTimeMixin;
