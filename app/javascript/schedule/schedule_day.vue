<template>
  <vue-cal
    hide-view-selector
    xsmall
    disable-date-prototypes
    :time-from="startTime"
    :time-step="timeStep"
    :snap-to-time="snapToTime"
    :selected-date="selectedDate"
    :sticky-split-labels="true"
    :minSplitWidth="150"
    :split-days="roomHeading"
    :disable-views="['years', 'year', 'month', 'week']"
    :time-cell-height="80"
    :editable-events="{ title: false, drag: true, resize: false, delete: false, create: false }"
    class="plano-sched-day vuecal--full-height-delete"
    ref="dayRoomGrid"
    :events="events"
    @event-drop="onEventDrop"
    @event-focus="onEventFocus"
    @event-mouse-enter="onEventEnter"
    @event-mouse-leave="onEventLeave"
    cellContextmenu
  >
  <!-- hover
    event-mouse-enter
    event-mouse-leave

    right click
    cell-contextmenu
  -->
    <template v-slot:title="{ title, view }">
      {{ formatDate(view.selectedDate, { weekday: 'long' }) }},
      {{ formatDate(view.selectedDate, { day: 'numeric', month: 'short' }) }}
    </template>
    <template v-slot:event="{ event, view }">
      <div class="d-flex flex-column">
        <div class="d-flex flex-row p-1 justify-content-between">
          <small class="event-time">
            {{ formatLocaleJsDate(event.start) }} - {{ formatDatetime(addMinutes(event.start, event.duration_mins)) }}
          </small>
          <b-icon-x @click="onDelete(event)"></b-icon-x>
        </div>
        <small>
          {{event.title}}
        </small>
      </div>
    </template>
  </vue-cal>
</template>

<script>
import VueCal from 'vue-cal'
import 'vue-cal/dist/vuecal.css'
import dateTimeMixin from '../components/date_time.mixin'
import modelUtilsMixin from "@/store/model_utils.mixin"
import { sessionModel } from '@/store/session.store'
import tableMixin from '../store/table.mixin';

const { DateTime } = require("luxon");

export default {
  name: "ScheduleDay",
  components: {
    VueCal
  },
  mixins: [
    dateTimeMixin,
    modelUtilsMixin,
    tableMixin
  ],
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
      default: 15
    },
    rooms: {
      type: Array
    },
    selectedDate: {
      type: String,
      required: true
    },
    timezone: {
      type: String,
      default: null
    },
    // which rooms to show (selected)
    selectedRooms: {
      type: Array,
      required: true
    }
  },
  data: () =>  ({
  }),
  computed: {
    events() {
      let res = []
      for (const session of this.collection) {
        let start_time = DateTime.fromISO(session.start_time).setZone(this.timezone)
        let end_time = DateTime.fromISO(session.end_time).setZone(this.timezone)
        // check it is for the right day
        if (start_time.toFormat('yyyy-MM-dd') == this.selectedDate) {
          // let new_event = this.$refs['dayRoomGrid'].createEvent(
          let new_event = {
            start: start_time.toFormat('yyyy-MM-dd HH:mm'),
            end: end_time.toFormat('yyyy-MM-dd HH:mm'),
            title: session.title,
            split: session.room_id,
            id: session.id,
            duration_mins: session.duration_mins
          }
          res.push(new_event)
        }
      }
      return res
    },
    roomHeading() {
      if (this.rooms) {
        let headings = this.rooms.map(
          obj => (
            {
              id: obj.id,
              class: 'room-col',
              label: obj.name,
              //  You can toggle the splits thanks to the hide property of each split in splitDays.
              hide: (this.selectedRooms.length ? !this.selectedRooms.includes(obj.id) : false)
            }
          )
        )
        return headings
      } else {
        return []
      }
    },
  },
  methods: {
    onEventFocus (e) {
      console.debug("******* SESSION Focus", e)
      // this.selectedEvent = event
      // TODO: dialog with the event name and times
      // this.showDialog = true
      // Prevent navigating to narrower view (default vue-cal behavior).
      // e.stopPropagation()
    },
    onEventEnter(e) {
      console.debug("******* SESSION Entered", e)
      // e.stopPropagation()
    },
    onEventLeave(e) {
      console.debug("******* SESSION Leave", e)
      // e.stopPropagation()
    },
    // onCreate(ev) {
    //   // console.debug("******** 1. CREATE EVENT", ev)
    // },
    onEventDrop ({ event, originalEvent, external }) {
      this.updateSession(event.id, event.start, event.split)
    },
    onDelete(ev) {
      this.updateSession(ev.id, null, null)
    },
    scrollBarElement: function() {
      return this.$refs['dayRoomGrid'].$el.getElementsByClassName('day-view')[0]
    },
    updateSession(id, start_time, room_id) {
      let session = this.get_model(sessionModel, id)
      session.start_time = start_time ? this.uiDateToTZDate(start_time) : null
      session.room_id = room_id
      this.save_model(sessionModel, session).then(
        () => {
          this.$emit("schedule-changed");
        }
      )
    }
  }
}
</script>

<style lang="scss">
@import '../stylesheets/style.scss';

.vuecal {
  height: unset;
}

.vuecal__no-event {
  display: none;
}

.vuecal__title-bar {
  color: $color-primary-4;
  background-color: $color-primary-1;
}

.vuecal__event {
  color: $color-secondary-2-4;
  background-color: $color-secondary-2-1;
  border-width: 1px;
  border-color: grey;
  border-style: solid;
}

.vuecal__arrow--prev,
.vuecal__arrow--prev {
  display: none;
}

.vuecal__arrow--next,
.vuecal__arrow--next {
  display: none;
}

.day-split-header,
.vuecal__cell .room-col {
  border-color: $color-primary-1;
  border-left-style: solid;
  border-width: 1px;
}

.event-time {
  font-size: smaller;
}

// Split header needs to be 20px so that long titles do not force mis-alignment...
.plano-sched-day .vuecal__split-days-headers {
  max-height: 20px;
}

.plano-sched-day .day-split-header {
  overflow: hidden;
  text-overflow: ellipsis;
  align-items: normal !important;
}
</style>
