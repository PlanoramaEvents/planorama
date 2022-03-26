<template>
  <div v-bind:class="dayColClass">
    <vue-cal
      hide-view-selector
      xsmall
      disable-date-prototypes
      active-view="day"
      style="height: 30em;"
      :editable-events="{ title: false, drag: true, resize: true, delete: true, create: true }"
      :disable-views="['years', 'year', 'month', 'week']"
      :time-cell-height="18"
      :time-from="startTime"
      :time-step="timeStep"
      :snap-to-time="timeStep"
      :min-date="day"
      :max-date="day"
      :selected-date="day"
      ref="dayColumn"
      :twelveHour="twelveHour"
      @event-drag-create="onCreate($event)"
      @event-delete="logEvents('event-delete', $event)"
      @event-duration-change="logEvents('event-duration-change', $event)"
      @event-drop="logEvents('event-drop', $event)"
    >
      <!-- :events="dayEvents" -->
      <template v-slot:title="{ title, view }">
        {{ $luxon(view.selectedDate.toISOString(), "cccc") }}<br />
        {{ $luxon(view.selectedDate.toISOString(), "d MMM") }}
      </template>
      <!-- @event-drop="logEvents('event-drop', $event)"
      @event-create="logEvents('event-create', $event)"
      @event-content-change="logEvents('event-content-change', $event)" -->

      <!-- :onEventCreate="onEventCreate" -->
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
    // value: {
    //   type: Object,
    //   default: () => {
    //     test: 'test'
    //   }
    // },
    startTime: {
      type: Number,
      default: 360
    },
    timeStep: {
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
    // TODO: change to a computed value based on initial events
    // i.e. we do not want their TZ info in there
    dayEvents: {}
  }),
  computed: {
    initialEvents() {
      return []
    },
    dayColClass() {
      let showScroll = this.showScrollBar ? '' : 'plano-col-no-bar'
      if (this.firstDay) {
        return `col-3 pr-0 plano-col ${showScroll}`
      } else {
        return `col-2 pr-0 pl-0 plano-col plano-first ${showScroll}`
      }
    }
  },
  methods: {
    logEvents(ty, ev) {
      // events have an _eid that makes them unique
      console.debug("*** EV ",ty, ev)
    },
    scrollBarElement: function() {
      return this.$refs['dayColumn'].$el.getElementsByClassName('vuecal__bg')[0]
    },
    onCreate(ev) {
      let slot = this.createAvailibilitySlot(ev._eid, ev.start, ev.end)
      this.dayEvents[slot.cid] = slot
      this.$emit('change', { day: this.day, slots: this.dayEvents })
    },
    createAvailibilitySlot(id, fromDate, toDate) {
      const startDate =this.uiDateToTZDate(fromDate)
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
    }
    // TODO
    // store the list of events without their timezone info?
    // onCreate - create an entry, emit change to parent
    // event-drag-create
    // onDelete - delete an entry, emit change to parent
    // event-delete
    // onChangeDuration - change an entry, emit change to parent
    // event-duration-change - change end time
    // event-drop - change start time

    // onEventCreate (ev, deleteEventFunction) {
    //   console.debug("We create an event", ev, this.dayEvents)
    //   // You can modify event here and return it.
    //   // You can also return false to reject the event creation.
    //   return ev
    // },
    // onChange(arg) {
    //   console.debug("Change", arg)
    // }
  }
}
</script>

<style lang="scss">
@import '../stylesheets/style.scss';

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

.vuecal__time-cell-label {
  color: $color-primary-4;
}

.plano-col .vuecal__arrow--prev {
  display: none;
}
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

.plano-first .vuecal__time-column,
.plano-first .vuecal__time-cell {
  width: 0px
}

.plano-first .vuecal__time-cell-label {
  display: none;
}
</style>
