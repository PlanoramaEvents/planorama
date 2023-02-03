<template>
  <div>
    <div class="d-flex flex-row pb-3">
      <div>
        What is the maximum number of program items you are willing to participate in across the entire duration of the convention?<br />
          <session-limit-editor
            v-model="person"
            :timezone="calTimeZone"
            model="session_limit"
            v-if="calTimeZone"
          >
          </session-limit-editor>
        <p>
          Under each day, highlight (click and drag) the times of day that you are available for programming in the calendar view below.
          You can create multiple blocks of time per day. <span v-if="eventVirtual" >The in-person convention time is currently displayed,
          and is Central Daylight Time (UTC-5). If you will be attending virtually,
          and want to enter your availability in that time zone, select that option from below the calendar.
          </span>
          <span v-if="!eventVirtual">The time is displayed in the convention time zone, which is currently {{timezone}}.</span>
        </p>
      </div>
    </div>
    <div class="d-flex flex-row" v-if="calTimeZone && start_time && end_time">
      <div class="d-flex flex-column">
        <availability-calendar
          v-model="person"
          :days="days"
          model="availability"
          :timezone="calTimeZone"
        ></availability-calendar>
        <!-- NOTE: The timezone selection for availability affects calendar AND limit display. -->
        <div class="mt-1 w-50" v-if="eventVirtual">
          Select time zone to work in:
          <b-form-select v-model="calTimeZone" :options="timeZoneOptions"></b-form-select>
        </div>
      </div>

      <div class="pl-2" style="flex: 1">
        <div class="container">
          <b-row class="my-1">
            <b-col sm="12">
              What is the maximum number of program items you are willing to participate in on each day?<br />
              <small class="text-muted">(These can add up to more than your convention maximum.)</small>
            </b-col>
          </b-row>
        </div>
        <session-limits
          v-model="person"
          :days="days"
          :timezone="calTimeZone"
          v-if="calTimeZone && days"
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
    <!-- {{ person.lock_version }} -->
    <availability-notes-field
      v-if="editable_person"
      v-model="editable_person"
      model="person"
      @input="onNotePatched"
    ></availability-notes-field>
  </div>
</template>

<script>
import AvailabilityCalendar from './availability_calendar.vue';
import ExclusionsPicker from './exclusions_picker.vue'
import SessionLimits from './session_limits.vue'
import SessionLimitEditor from './session_limit_editor.vue'
import AvailabilityNotesField from './availability_notes_field';
import TimezoneSelector from "../components/timezone_selector.vue"
import searchStateMixin from "@/store/search_state.mixin"
import { eventVirtualMixin } from '@/shared/event-virtual.mixin';

const { DateTime } = require("luxon");

export default {
  name: "AvailabilityAndInterests",
  mixins: [
    searchStateMixin,
    eventVirtualMixin
  ],
  components: {
    SessionLimitEditor,
    AvailabilityCalendar,
    ExclusionsPicker,
    SessionLimits,
    AvailabilityNotesField,
    TimezoneSelector
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
      //type: DateTime,
      // default: null
      required: true
    },
    end_time: {
      //type: DateTime,
      required: true
    },
    timezone: {
      type: String,
      default: null
    }
  },
  data: () => ({
    editable_person: null,
    // NOTE: if there are more than 5 days in the con we need to change display
    options: [
          { value: null, text: 'Please select an option' },
          { value: 'Europe/Paris', text: 'Europe/Paris' },
          { value: 'America/Los_Angeles', text: 'America/Los_Angeles' },
          { value: 'Australia/Victoria', text: 'Australia/Victoria' },
        ],
  }),
  computed: {
    timeZoneOptions() {
      let your_zone = this.person.timezone
      let enable_your_zone = your_zone && your_zone.length > 0

      let your_zone_text = `Your Timezone during con -- ${your_zone}`

      if (!enable_your_zone) {
        your_zone_text = "Your Timezone during con -- no value set"
      }

      return [
        {
          text: `Timezone of Convention -- ${this.timezone}`,
          value: this.timezone
        },
        {
          text: your_zone_text,
          value: this.person.timezone,
          disabled: !enable_your_zone
        }
      ]
    },
    days() {
      if (!this.start_time || !this.end_time) return []

      let start_day = this.start_time.setZone(this.calTimeZone).startOf('day')
      let end_day = this.end_time.setZone(this.calTimeZone).endOf('day')
      let nbr_days = Math.round(end_day.diff(start_day, 'days').as('days'))
      let res = []
      for (let i = 0; i < nbr_days; i++ ) {
        let d = start_day.toFormat('yyyy-MM-dd') //toLocaleString(DateTime.DATE_SHORT)
        res.push(d)
        start_day = start_day.plus({days: 1})
      }
      return res
    },
  },
  methods: {
    onNotePatched(arg) {
      this.$emit('input',this.editable_person)
    }
  },
  mounted() {
    this.calTimeZone ||= this.timezone
    this.editable_person = this.person
  }
}
</script>

<style>

</style>
