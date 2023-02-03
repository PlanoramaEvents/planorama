<template>
  <div class="d-flex flex-row">
    <div class="">
      Availability<br/>
      <small class="text-muted">{{AVAILABILITY_DESCRIPTION}}</small>
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
      <small class="text-muted">* times shown in {{display_timezone}}</small>
      <!-- TODO: add in a selector for timezone of the con/your TZ during the con -->
    </div>
    <div class="p-2 selected-availabilities">
      <p>Selected Times</p>
      <div v-for="avail in sortedAvailabilities" :key="avail.id">
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
// import personSessionMixin from '../auth/person_session.mixin';
import {
  AVAILABILITY_DESCRIPTION
} from '@/constants/strings';

const { DateTime } = require("luxon");

export default {
  name: "AvailabilityCalendar",
  mixins: [availabilityMixin],
  components: {
    AvailabilityTimePicker
  },
  model: {
    prop: 'person'
  },
  props: {
    person: {
      type: Object,
      required: true
    },
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
    DateTime: DateTime,
    AVAILABILITY_DESCRIPTION
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
    // formatDate(date, config) {
    //   // return DateTime.fromISO(date).setZone(this.timezone).toFormat(config)
    //   return DateTime.fromISO(date, {zone: this.timezone}).toFormat(config)
    // },
    formatLocaleDate(date, config) {
      // return DateTime.fromISO(date).setZone(this.timezone).toLocaleString(config)
      return DateTime.fromISO(date, {zone: this.timezone}).toLocaleString(config)
    },
    syncScrolling() {
      for (const day of this.days) {
        let component = this.$refs[`day-${day}`][0].scrollBarElement()
        let targets = this.days.filter(d => d != day)

        component.addEventListener("scroll",
          this.syncScroll.bind(event,component,targets),
          false
        )
      }
    },
    init: function(arg) {
      this.syncScrolling();
      this.get_availability({person: this.person}).then(
        (availabilities) => {
          let coll = Object.values(availabilities)
          let iniialVals = coll.map((a) => { return {start: DateTime.fromISO(a.start_time) , end: DateTime.fromISO(a.end_time)} })
          for (const day of this.days) {
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
      this.update_availability({person: this.person, params: this.dayEvents})
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
    this.$nextTick(
      () => {
        this.init()
      }
    )
  }
}
</script>

<style>
.selected-availabilities {
  width: 35%;
}
</style>
