<template>
  <div v-bind:class="dayColClass">
    <vue-cal
      hide-view-selector
      xsmall
      disable-date-prototypes
      active-view="day"
      style="height: 300px;"
      :editable-events="{ title: false, drag: true, resize: true, delete: false, create: true }"
      :disable-views="['years', 'year', 'month', 'week']"
      :time-cell-height="18"
      :time-from="startTime"
      :time-step="timeStep"
      :snap-to-time="snapToTime"
      :min-date="day"
      :max-date="day"
      :selected-date="day"
      ref="dayColumn"
      :twelveHour="twelveHour"
      :timezone="timezone"
      @event-drag-create="onCreate($event)"
      @event-delete="onDelete($event)"
      @event-duration-change="onUpdate($event)"
      @event-drop="onUpdate($event)"
      class="vuecal--full-height-delete"
    >
      <template v-slot:title="{ title, view }">
        {{ formatDate(view.selectedDate, { weekday: 'long' }) }}<br />
        {{ formatDate(view.selectedDate, { day: 'numeric', month: 'short' }) }}
      </template>
      <template v-slot:event="{ event, view }">
        <div class="d-flex flex-row">
          <small class="vuecal__event-time">
            <span>{{ formatLocaleDate(event.start) }} - </span><br/>
            <span>{{ formatLocaleDate(event.end) }}</span>
          </small>
          <b-icon-trash @click="onDelete(event)" class="ml-auto mt-1"></b-icon-trash>
        </div>
      </template>
    </vue-cal>
  </div>
</template>

<script>
import VueCal from 'vue-cal'
import 'vue-cal/dist/vuecal.css'

const { DateTime } = require("luxon");

export default {
  name: "AvailabilityTimePicker",
  components: {
    VueCal
  },
  props: {
    startTime: {
      type: Number,
      default: 0 //360
    },
    timeStep: {
      type: Number,
      default: 60
    },
    snapToTime: {
      type: Number,
      default: 30
    },
    day: {
      type: String,
      default: null
    },
    firstDay: {
      type: Boolean,
      default: false
    },
    showScrollBar: {
      type: Boolean,
      default: false
    },
    timezone: {
      type: String,
      default: null
    },
    twelveHour: {
      type: Boolean,
      default: false
    }
  },
  data: () =>  ({
    dayEvents: {},
    // TODO: we need to pass this in based on TZ
    // conventionHours: {
    //   1: { from: 8.5 * 60, to: 24 * 60, class: 'convention-hours' },
    //   2: { from: 8.5 * 60, to: 24 * 60, class: 'convention-hours' },
    //   3: { from: 8.5 * 60, to: 24 * 60, class: 'convention-hours' },
    //   4: { from: 8.5 * 60, to: 24 * 60, class: 'convention-hours' },
    //   5: { from: 8.5 * 60, to: 24 * 60, class: 'convention-hours' },
    //   6: { from: 8.5 * 60, to: 24 * 60, class: 'convention-hours' },
    //   7: { from: 8.5 * 60, to: 24 * 60, class: 'convention-hours' },
    // }
  }),
  computed: {
    dayColClass() {
      let showScroll = this.showScrollBar ? '' : 'plano-col-no-bar'
      if (this.firstDay) {
        return `pr-0 plano-first ${showScroll}`
      } else {
        return `pr-0 pl-0 plano-col ${showScroll}`
      }
    }
  },
  methods: {
    formatLocaleDate(date) {
      let res = DateTime.fromJSDate(date).toLocaleString(DateTime.TIME_SIMPLE)
      // console.debug("**** D", date, DateTime.TIME_SIMPLE, res)
      return res //date.toLocaleString(DateTime.TIME_SIMPLE)
    },
    formatDate(date, config) {
      // return DateTime.fromISO(date).toFormat(config)
      // console.debug("**** D", date, config)
      // return DateTime.fromISO(date, {zone: this.timezone}).toLocaleString(config)
      // TODO: use the users locale or browsers locale here
      return date.toLocaleString('en-US',config)
    },
    // logEvents(ty, ev) {
    //   // events have an _eid that makes them unique
    //   console.debug("*** EV ",ty, ev)
    // },
    scrollBarElement: function() {
      return this.$refs['dayColumn'].$el.getElementsByClassName('vuecal__bg')[0]
    },
    onCreate(ev) {
      let slot = this.createAvailibilitySlot(ev._eid, ev.start, ev.end)
      this.dayEvents[slot.cid] = slot
      this.$emit('change', slot )
    },
    onUpdate(ev) {
      let slot = this.createAvailibilitySlot(ev.event._eid, ev.event.start, ev.event.end)
      this.dayEvents[slot.cid] = slot
      this.$emit('update', slot )
    },
    onDelete(ev) {
      let cid = ev._eid
      // remove element with _eid == cid from the arrays
      this.dayEvents[cid] = null
      this.$refs['dayColumn'].mutableEvents = this.$refs['dayColumn'].mutableEvents.filter(
        (e) => e._eid != cid
      )
      this.$refs['dayColumn'].view.events = this.$refs['dayColumn'].view.events.filter(
        (e) => e._eid != cid
      )
      this.$emit('delete', cid )
    },
    createAvailibilitySlot(id, fromDate, toDate) {
      const startDate = this.uiDateToTZDate(fromDate)
      const endDate = this.uiDateToTZDate(toDate)

      return {
        cid: id,
        start: startDate,
        end: endDate
      }
    },
    uiDateToTZDate(date) {
      return DateTime.fromObject({
        year: date.getFullYear(),
        month: date.getMonth() +1,
        day: date.getDate(),
        hour: date.getHours(),
        minute: date.getMinutes()},
        { zone: this.timezone }
      )
    },
    clearAllEvents() {
      this.dayEvents = {}
      this.$refs['dayColumn'].mutableEvents = []
      this.$refs['dayColumn'].view.events = []
    },
    init(initialEvents) {
      this.clearAllEvents()
      let startingVals = []
      for (const ev of initialEvents) {
        let new_event = this.$refs['dayColumn'].createEvent(
          ev.start.setZone(this.timezone).toFormat('yyyy-MM-dd HH:mm'),
          ev.end.diff(ev.start, 'minutes').as('minutes')
        )
        let slot = this.createAvailibilitySlot(new_event._eid, new_event.start, new_event.end)
        this.dayEvents[slot.cid] = slot
        startingVals.push(slot)
      }

      return startingVals
    }
  }
}
</script>

<style lang="scss">
@import '../stylesheets/style.scss';

// .convention-hours {
//   background-color: white;
// }
//
// .vuecal__cell-content {background-color: rgba(127, 127, 127, 0.2);}

.vuecal__no-event {
  display: none;
}

.vuecal__title-bar {
  color: $color-primary-4;
  background-color: $color-primary-1;
}

.vuecal__event {
  color: $color-secondary-2-4;
  background-color: $color-secondary-2-1; //$color-secondary-1-1;
}

.plano-first .vuecal__time-column {
  border-right: 1px solid black;
}

.plano-first .vuecal__title {
  padding-left: 50px;
}

.plano-first .vuecal__arrow--prev,
.plano-col .vuecal__arrow--prev {
  display: none;
}

.plano-first .vuecal__arrow--next,
.plano-col .vuecal__arrow--next {
  display: none;
}

/* Hide the scrollbar(s) */
.plano-col-no-bar .vuecal__bg::-webkit-scrollbar {
  display: none;
}

/* Hide scrollbar for IE, Edge and Firefox */
.plano-col-no-bar .vuecal__bg {
  -ms-overflow-style: none;  /* IE and Edge */
  scrollbar-width: none;  /* Firefox */
}

.plano-first {
  min-width: 150px;
}

.plano-col {
  min-width: 100px;
}

.plano-col .vuecal__time-column,
.plano-col .vuecal__time-cell {
  width: 0px
}

.plano-col .time-display,
.plano-col .vuecal__time-cell-label {
  display: none;
}

// .vuecal__event-time,
.vuecal__time-cell-label {
  font-size: smaller;
}
</style>
