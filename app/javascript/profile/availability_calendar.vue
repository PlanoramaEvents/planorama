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
        />
        <!-- timezone='America/Los_Angeles' -->
        <!-- <div class="col-1">
          results
        </div> -->
      </div>
      <!--
      :startTime (minutes)
      :timezone (UTC offset)
      :initialEvents
      -->

    </div>
    <div class="col-6">
      {{ eventArr }}
    </div>
  </div>
</template>

<script>
import AvailabilityTimePicker from './availability_time_picker'

export default {
  name: "AvailabilityCalendar",
  props: {
    days: {
      type: Array,
      required: true
    }
  },
  data: () =>  ({
    // TODO: change to a computed value based on initial events
    // i.e. we do not want their TZ info in there
    dayEvents: new Map()
  }),
  components: {
    AvailabilityTimePicker
  },
  computed: {
    eventArr() {
      // TODO: sort then return array
      return [...this.dayEvents.entries()];
    }
  },
  methods: {
    init: function(arg) {
      for (const day of this.days) {
        let component = this.$refs[`day-${day}`][0].scrollBarElement()
        let targets = this.days.filter(d => d != day)

        component.addEventListener("scroll",
          this.syncScroll.bind(event,component,targets),
          false
        )
      }
    },
    onChange(arg) {
      // console.debug("*** CHANGE: ", arg)
      // this.dayEvents[arg.day] = arg.slots
      // THis works, but is kind of crappy
      this.dayEvents = new Map(this.dayEvents.set(arg.day, arg.slots));
      // this.dayEvents.push(arg.slots)
      // This is not triggering a change (or watch) because it is a hash ....
      // console.debug("*** CHANGE: ", this.dayEvents)
      // this.$emit('onchange', this.dayEvents);
    },
    // TODO: this iniates lots of extra events ...
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
