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
      :timezone="timezone"
      @event-drag-create="onCreate($event)"
      @event-delete="onDelete($event)"
      @event-duration-change="onUpdate($event)"
      @event-drop="onUpdate($event)"
    >
      <template v-slot:title="{ title, view }">
        {{ formatDate(view.selectedDate.toISOString(), "cccc") }}<br />
        {{ formatDate(view.selectedDate.toISOString(), "d MMM") }}
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
    // We do not want their TZ info in there
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
    formatDate(date, config) {
      return DateTime.fromISO(date).toFormat(config)
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
      this.dayEvents[cid] = null
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
    init(initialEvents) {
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
