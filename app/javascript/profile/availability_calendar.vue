<template>
  <div class="row">
    <div class="col-6">
      <div class="row">
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
    </div>
    <div class="col-6">
      <div v-for="avail in sortedAvailabilities">
        {{ formatDate(avail.start, 'cccc') }}
        {{ formatLocaleDate(avail.start, DateTime.TIME_SIMPLE) }} -
        {{ formatLocaleDate(avail.end, DateTime.TIME_SIMPLE) }}
        {{ formatDate(avail.end, 'ZZZZ') }}
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
    }
  },
  methods: {
    formatDate(date, config) {
      // TODO: TZ
      return DateTime.fromISO(date).toFormat(config)
    },
    formatLocaleDate(date, config) {
      // TODO: TZ
      return DateTime.fromISO(date).toLocaleString(config)
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

            let init_events = this.$refs[`day-${day}`][0].init(iniialVals.filter((a) => a.start.toFormat("yyyy-MM-dd") == day))

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
</style>
