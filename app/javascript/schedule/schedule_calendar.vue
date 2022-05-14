<template>
  <div class="all-days-sched" v-if="initialSessions">
    <!-- Eeach schedule day has an eid for the event etc, which we can map to the actual session ... -->
    <schedule-day
      v-for="day in days" :key="day"
      :ref="'day-'+day"
      :rooms="rooms"
      :selected-date="day"
      :timezone="timezone"
      @schedule-changed="onScheduleChanged"
      :initialSessions="initialSessions"
    ></schedule-day>
  </div>
</template>

<script>
import ScheduleDay from './schedule_day'
import tableMixin from '../store/table.mixin';

export default {
  name: "ScheduleCalendar",
  components: {
    ScheduleDay
  },
  mixins: [
    tableMixin
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
    initialSessions: null
  }),
  watch: {
    sortedCollection(n,o) {
      // console.debug("sorted coll changed")
      if (n.length > 0) {
        this.initialSessions = n
      }
    },
    // initialSessions(n,o) {
    //   console.debug("initialSessions coll changed", n)
    // }
  },
  methods: {
    onScheduleChanged: function() {
      this.$emit("schedule-changed");
    },
    init: function() {
      this.fetchPaged(false).then(
        () => {
          if (this.sortedCollection && this.sortedCollection.length == 0) {
            this.initialSessions = []
          }

          // $nextTick ensures that the DOM is rendered... which is usefull
          // when we want to do DOM type functions...
          this.$nextTick(
            () => {
              for (const day of this.days) {
                let component = this.$refs[`day-${day}`][0].scrollBarElement()
                let targets = this.days.filter(d => d != day)

                component.addEventListener(
                  "scroll",
                  this.syncScroll.bind(event,component,targets),
                  false
                )
              }
            }
          )
        }
      )
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
