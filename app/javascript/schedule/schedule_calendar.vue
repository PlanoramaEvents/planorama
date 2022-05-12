<template>
  <div class="all-days-sched">
    <!-- Eeach schedule day has an eid for the event etc, which we can map to the actual session ... -->
    <schedule-day
      v-for="day in days" :key="day"
      :ref="'day-'+day"
      :rooms="rooms"
      :selected-date="day"
      :timezone="timezone"
    ></schedule-day>
  </div>
</template>

<script>
import ScheduleDay from './schedule_day'
// import modelUtilsMixin from "@/store/model_utils.mixin";
// import settingsMixin from "@/store/settings.mixin";
// import { roomModel } from '../store/room.store.js';

const { DateTime } = require("luxon");

export default {
  name: "ScheduleCalendar",
  components: {
    ScheduleDay
  },
  mixins: [
  ],
  props: {
    rooms: {
      type: Array
    },
    days: {
      type: Array,
      default: []
    },
    timezone: {
      type: String,
      default: null
    }
  },
  data: () =>  ({
  }),
  computed: {
  },
  methods: {
    init: function() {
      // console.debug("********** ", this.days)
      for (const day of this.days) {
        let component = this.$refs[`day-${day}`][0].scrollBarElement()
        let targets = this.days.filter(d => d != day)

        component.addEventListener(
          "scroll",
          this.syncScroll.bind(event,component,targets),
          false
        )
        // let init_events = this.$refs[`day-${day}`][0].init(iniialVals.filter((a) => a.start.setZone(this.timezone).toFormat("yyyy-MM-dd") == day))
        // this.dayEvents = this.dayEvents.concat(init_events)
      }
    },
    syncScroll: function(day, targets, event) {
      for (const target of targets) {
        let el = this.$refs[`day-${target}`][0].scrollBarElement()
        el.scrollLeft = day.scrollLeft
      }
    }
  },
  mounted() {
    this.init()
  }
}
</script>

<style lang="scss">
.all-days-sched {
  overflow-y: scroll;
  // height: 600px;
}
</style>
