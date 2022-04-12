<template>
  <div>
    <div class="d-flex flex-row pb-3">
      <div>
        Convention maximum number of program items willing to participate in:<br />
        <b-col sm="4">
          <session-limit-editor
            v-model="person"
            :timezone="timezone"
            model="session_limit"
          >
          </session-limit-editor>
        </b-col>
      </div>
    </div>
    <div class="d-flex flex-row">
      <availability-calendar
        v-model="person"
        :days="days"
        model="availability"
        :timezone="timezone"
      ></availability-calendar>
      <div class="pl-2" style="max-width: 25%;">
        <b-row class="my-1">
          <b-col sm="12">
            Daily panel maximum willing to participate in (regardless of convention maximum)
          </b-col>
        </b-row>
        <session-limits
          v-model="person"
          :days="days"
          :timezone="timezone"
        >
        </session-limits>
      </div>
    </div>
    <div class="d-flex flex-row">
      <exclusions-picker
        v-model="person"
        model="person_exclusion"
      ></exclusions-picker>
    </div>
    <availability-notes-field
      v-model="person"
      model="person"
    ></availability-notes-field>
  </div>
</template>

<script>
import AvailabilityCalendar from './availability_calendar.vue';
import ExclusionsPicker from './exclusions_picker.vue'
import SessionLimits from './session_limits.vue'
import SessionLimitEditor from './session_limit_editor.vue'
import AvailabilityNotesField from './availability_notes_field';

const { DateTime } = require("luxon");

export default {
  name: "AvailabilityAndInterests",
  components: {
    SessionLimitEditor,
    AvailabilityCalendar,
    ExclusionsPicker,
    SessionLimits,
    AvailabilityNotesField
  },
  model: {
    prop: 'person'
  },
  props: {
    person: {
      type: Object,
      required: true
    },
    start_time: {
      type: DateTime,
      // default: null
      required: true
    },
    end_time: {
      type: DateTime,
      required: true
    },
    timezone: {
      type: String,
      default: null
    }
  },
  data: () => ({
    // NOTE: if there are more than 5 days in the con we need to change display
    options: [
          { value: null, text: 'Please select an option' },
          { value: 'Europe/Paris', text: 'Europe/Paris' },
          { value: 'America/Los_Angeles', text: 'America/Los_Angeles' },
          { value: 'Australia/Victoria', text: 'Australia/Victoria' },
        ],
  }),
  computed: {
    days() {
      // TODO: we need to check this
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
  }
}
</script>

<style>

</style>
