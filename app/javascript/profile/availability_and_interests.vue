<template>
  <div>
    <div class="mb-3">
      Availbility and Interests
    </div>
    <!-- <b-form-select v-model="timezone" :options="options"></b-form-select> -->
    <availability-calendar
      :days="days"
      model="availability"
      :timezone="timezone"
    ></availability-calendar>
    <!-- timezone="Europe/Paris" -->
  </div>
</template>

<script>
import AvailabilityCalendar from './availability_calendar.vue';
// import { personModel as model } from '../store/person.store';

const { DateTime } = require("luxon");

export default {
  name: "AvailabilityAndInterests",
  props: {
    start_time: {
      type: DateTime,
      default: null
      // required: true
    },
    end_time: {
      type: DateTime,
      default: null
    }
  },
  data: () => ({
    // NOTE: if there are more than 5 days in the con we need to change display
    timezone: null,
    options: [
          { value: null, text: 'Please select an option' },
          { value: 'Europe/Paris', text: 'Europe/Paris' },
          { value: 'America/Los_Angeles', text: 'America/Los_Angeles' },
          { value: 'Australia/Victoria', text: 'Australia/Victoria' },
        ],
  }),
  computed: {
    days() {
      // base on TZ as well
      let start_day = this.start_time.setZone(this.timezone).startOf('day')
      let end_day = this.end_time.setZone(this.timezone).endOf('day')
      let nbr_days = Math.round(end_day.diff(start_day, 'days').as('days'))
      let res = []
      for (let i = 0; i < nbr_days; i++ ) {
        let d = start_day.toFormat('yyyy-MM-dd') //toLocaleString(DateTime.DATE_SHORT)
        res.push(d)
        start_day = start_day.plus({days: 1})
      }
      return res
    }
  },
  components: {
    AvailabilityCalendar
  }
}
</script>

<style>

</style>
