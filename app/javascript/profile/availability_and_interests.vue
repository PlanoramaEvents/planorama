<template>
  <div>
  <div class="d-flex flex-row pb-3">
    <div>
      Convention maximum number of program items willing to participate in:<br />
      <b-col sm="4">
        <b-form-input></b-form-input>
      </b-col>
    </div>
    <!-- <b-form-select v-model="timezone" :options="options"></b-form-select> -->
  </div>
  <div class="d-flex flex-row">
    <!-- <div class="mb-3">
      Availbility and Interests
    </div> -->
      <availability-calendar
        :days="days"
        model="availability"
        :timezone="timezone"
      ></availability-calendar>
      <div class="pl-2" style="max-width: 20%;">
        <b-row class="my-1">
          <b-col sm="12">
            Daily panel maximum willing to participate in (regardless of convention maximum)
          </b-col>
        </b-row>
        <b-row class="my-1">
          <b-col sm="4">
            <b-form-input></b-form-input>
          </b-col>
          <b-col sm="8">
            <label for="input-none">Thursday</label>
          </b-col>
        </b-row>
        <b-row class="my-1">
          <b-col sm="4">
            <b-form-input></b-form-input>
          </b-col>
          <b-col sm="8">
            <label for="input-none">Friday</label>
          </b-col>
        </b-row>
        <b-row class="my-1">
          <b-col sm="4">
            <b-form-input></b-form-input>
          </b-col>
          <b-col sm="8">
            <label for="input-none">Saturday</label>
          </b-col>
        </b-row>
        <b-row class="my-1">
          <b-col sm="4">
            <b-form-input></b-form-input>
          </b-col>
          <b-col sm="8">
            <label for="input-none">Sunday</label>
          </b-col>
        </b-row>
        <b-row class="my-1">
          <b-col sm="4">
            <b-form-input></b-form-input>
          </b-col>
          <b-col sm="8">
            <label for="input-none">Monday</label>
          </b-col>
        </b-row>
      </div>
    <div class="pl-2">
      Do not schedule me against these specific  events:<br />
      <!-- value="accepted"
      unchecked-value="not_accepted" -->
      <b-form-checkbox name="checkbox-1">
      Hugo Award Ceremony
      </b-form-checkbox>
      <b-form-checkbox name="checkbox-1">
      Hugo Award Ceremony rehearsal
      </b-form-checkbox>
      <b-form-checkbox name="checkbox-1">
      Masquerade
      </b-form-checkbox>
      <b-form-checkbox name="checkbox-1">
      Masquerade rehearsal
      </b-form-checkbox>
      <b-form-checkbox name="checkbox-1">
      Opening Ceremony
      </b-form-checkbox>
      <b-form-checkbox name="checkbox-1">
      Opening Ceremony rehearsal
      </b-form-checkbox>
      <b-form-checkbox name="checkbox-1">
      Closing Ceremony
      </b-form-checkbox>
      <b-form-checkbox name="checkbox-1">
      Closing Ceremony rehearsal
      </b-form-checkbox>
      <b-form-checkbox name="checkbox-1">
      WSFS Business Meeting
      </b-form-checkbox>
      <b-form-checkbox name="checkbox-1">
      Mark Protection Committee meetings
      </b-form-checkbox>
      <b-form-checkbox name="checkbox-1">
      Joe Siclari and Edie Stern GoH highlight session
      </b-form-checkbox>
      <b-form-checkbox name="checkbox-1">
      Floyd Norman highlight session
      </b-form-checkbox>
      <b-form-checkbox name="checkbox-1">
      Charles deLint highlight session
      </b-form-checkbox>
      <b-form-checkbox name="checkbox-1">
      Earle Korshak highlight session
      </b-form-checkbox>
      <b-form-checkbox name="checkbox-1">
      Eve L. Ewing highlight session
      </b-form-checkbox>
      <b-form-checkbox name="checkbox-1">
      Gene Ha highlight session
      </b-form-checkbox>
      <b-form-checkbox name="checkbox-1">
      Eric Wilkerson highlight session
      </b-form-checkbox>
      <b-form-checkbox name="checkbox-1">
      Answer to Chicago question
      </b-form-checkbox>
    </div>
  </div>
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
