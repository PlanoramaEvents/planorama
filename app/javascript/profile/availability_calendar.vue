<template>
  <div class="row">
    <availability-time-picker
      v-for="day in days" :key="day"
      :day="day"
      :firstDay="day === days[0]"
      :ref="'day-'+day"
    />
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
  components: {
    AvailabilityTimePicker
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
