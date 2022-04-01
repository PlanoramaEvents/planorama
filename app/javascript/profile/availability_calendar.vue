<template>
  <div class="d-flex flex-row">
    <div class="">
      Availability
      <!-- <b-form-select v-model="timezone" :options="options"></b-form-select> -->
      <div class="d-flex flex-row">
        <availability-time-picker
          v-for="day in days" :key="day"
          :day="day"
          :firstDay="day === days[0]"
          :ref="'day-'+day"
          :showScrollBar="day === days[days.length -1]"
          :twelveHour="true"
          :dayEvents="dayEvents"
          @change="onChange"
          @update="onUpdate"
          @delete="onDelete"
          :timezone="timezone"
        />
      </div>
      * times shown in {{display_timezone}}
    </div>
    <div class="p-2 selected-availabilities">
      <div v-for="avail in sortedAvailabilities">
        {{ formatLocaleDate(avail.start, { weekday: 'long' }) }}
        {{ formatLocaleDate(avail.start, DateTime.TIME_SIMPLE) }} -
        {{ formatLocaleDate(avail.end, {hour: 'numeric', minute: '2-digit', timeZoneName: 'short'} ) }}
      </div>
    </div>
  </div>
</template>

<script>
import AvailabilityTimePicker from './availability_time_picker'
import availabilityMixin from '../store/availability.mixin'
import personSessionMixin from '../auth/person_session.mixin';

const { DateTime } = require("luxon");

export default {
  name: "AvailabilityCalendar",
  mixins: [availabilityMixin, personSessionMixin],
  components: {
    AvailabilityTimePicker
  },
  props: {
    days: {
      type: Array,
      required: true
    },
    timezone: {
      type: String,
      default: null
    }
  },
  data: () =>  ({
    dayEvents: new Array(),
    DateTime: DateTime
  }),
  computed: {
    sortedAvailabilities() {
      let col = this.dayEvents.sort((a, b) => a.start > b.start)
      return col
    },
    display_timezone() {
      return 'UTC' + DateTime.fromISO(this.days[0]).setZone(this.timezone).toFormat('Z (ZZZZZ)')
    }
  },
  watch: {
    timezone: function (nv, ov) {
      this.dayEvents = []
      this.init()
    }
  },
  methods: {
    formatDate(date, config) {
      return DateTime.fromISO(date).setZone(this.timezone).toFormat(config)
    },
    formatLocaleDate(date, config) {
      return DateTime.fromISO(date).setZone(this.timezone).toLocaleString(config)
    },
    init: function(arg) {
      this.get_availability().then(
        () => {
          let iniialVals = this.collection.map((a) => { return {start: DateTime.fromISO(a.start_time) , end: DateTime.fromISO(a.end_time)} })
          for (const day of this.days) {
            let component = this.$refs[`day-${day}`][0].scrollBarElement()
            let targets = this.days.filter(d => d != day)

            component.addEventListener("scroll",
              this.syncScroll.bind(event,component,targets),
              false
            )

            let init_events = this.$refs[`day-${day}`][0].init(iniialVals.filter((a) => a.start.setZone(this.timezone).toFormat("yyyy-MM-dd") == day))

            this.dayEvents = this.dayEvents.concat(init_events)
          }
        }
      )
    },
    onDelete(cid) {
      let evs = this.dayEvents.filter(
        (e) => (e.cid != cid)
      )
      this.dayEvents = evs
      this.updateAvailabilities()
    },
    onChange(arg) {
      this.dayEvents.push(arg)
      this.updateAvailabilities()
    },
    onUpdate(arg) {
      // remove then add
      this.dayEvents = this.dayEvents.filter(
        (e) => (e.cid != arg.cid)
      )
      this.dayEvents.push(arg)
      this.updateAvailabilities()
    },
    updateAvailabilities() {
      this.update_availability({person: this.currentUser, params: this.dayEvents})
    },
    // TODO: this initiates lots of extra events ...
    // can we set scroll top without setting off an event?
    syncScroll: function(day, targets, event) {
      for (const target of targets) {
        let el = this.$refs[`day-${target}`][0].scrollBarElement()
        el.scrollTop = day.scrollTop
      }
    }
  },
  mounted() {
    this.init()
  }
}
</script>

<style>
.selected-availabilities {
  font-size: 10pt;
}
</style>
