<template>
  <!--
    How about an empty day so we have a fixed top cal?
    and we can hid the split header in the other cals
  -->
  <!-- Eeach schedule day has an eid for the event etc, which we can map to the actual session ... -->
  <div>
    <b-overlay :show="loading" rounded="sm" no-center>
      <template #overlay>
        <b-spinner label="Spinning" class="position-relative" style="top: 200px; left: 50%;"></b-spinner>
      </template>
      <schedule-day
        v-for="day in days" :key="day"
        :ref="'day-'+day"
        :rooms="rooms"
        :selected-date="day"
        :selectedRooms="selectedRooms"
        :timezone="timezone"
        @schedule-changed="onScheduleChanged"
        :model="sessionModel"
        @show-conflicts="onShowConflicts"
      ></schedule-day>
    </b-overlay>
  </div>
</template>

<script>
import ScheduleDay from './schedule_day'
import tableMixin from '../store/table.mixin';
import { sessionModel } from '@/store/session.store'

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
    },
    selectedRooms: {
      type: Array,
      required: true
    }
  },
  data: () =>  ({
    sessionModel,
    loading: false
  }),
  methods: {
    onScheduleChanged: function(id) {
      this.$emit("schedule-changed", id);
    },
    onShowConflicts: function(session_id) {
      this.$emit("show-conflicts", session_id);
    },
    init: function() {
      this.loading = true
      this.fetchAll({}).then(
        () => {
          // $nextTick ensures that the DOM is rendered... which is usefull
          // when we want to do DOM type functions...
          this.$nextTick(
            () => {
              this.loading = false
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
</style>
