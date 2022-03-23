<template>
  <div class="row">
    <availability-time-picker
      day="2022-09-01"
      firstDay
    />
    <availability-time-picker
      day="2022-09-02"
    />
    <availability-time-picker
      day="2022-09-03"
    />
    <availability-time-picker
      day="2022-09-04"
    />
    <availability-time-picker
      day="2022-09-05"
    />
  </div>
</template>

<script>
import AvailabilityTimePicker from './availability_time_picker'

export default {
  name: "AvailabilityCalendar",
  data: () => ({
    // minDate: "2022-09-01",
    // maxDate: "2022-09-05"
  }),
  components: {
    AvailabilityTimePicker
  },
  methods: {
    // onEventClick (event, e) {
    //   // Prevent navigating to narrower view (default vue-cal behavior).
    //   e.stopPropagation()
    // },
    // onReady: function(arg) {
    //   let el = this.$refs['day2'].$el.getElementsByClassName('vuecal__bg')
    //   this.day2 = this.$refs['day2'].$el.getElementsByClassName('vuecal__bg')[0]
    //   // console.debug("**** READY ", el[0])
    //   el[0].addEventListener("scroll", this.syncScroll) //function() { console.debug('**** FCK')}) //.onscroll = this.syncScroll
    //   this.day1 = this.$refs['day1'].$el.getElementsByClassName('vuecal__bg')[0]
    // },
    // syncScroll: function(arg) {
    //   console.debug("**** SYNC", arg)
    //   this.day1.scrollTop = this.day2.scrollTop
    // }
  }
}
</script>

<style>
</style>
