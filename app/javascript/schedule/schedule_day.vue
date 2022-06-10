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
    :on-event-click="onEventClick"
  >
    <template v-slot:title="{ title, view }">
      {{ formatDate(view.selectedDate, { weekday: 'long' }) }},
      {{ formatDate(view.selectedDate, { day: 'numeric', month: 'short' }) }}
    </template>
    <template v-slot:event="{ event, view }">
      <div
        class="d-flex flex-column"
        style="height: 100%;"
        v-bind:class="{ 'selected-event': (selected && (selected.id == event.id)), 'event-with-conflicts': (event.has_conflicts && !(selected && (selected.id == event.id))) }"
      >
        <div v-b-popover.hover="hoverText(event)" :title="event.title" >
          <div class="d-flex flex-row p-1 justify-content-between">
            <!-- NOTE: using mouseup because that is what on-event-click is using and we want this to stop the event click sesson select -->
            <b-iconstack v-if="event.has_conflicts"
              @mouseup="conflictsForSession($event, event.id)"
            >
              <b-icon-exclamation-triangle-fill stacked variant="warning"></b-icon-exclamation-triangle-fill>
              <b-icon-exclamation-triangle stacked ></b-icon-exclamation-triangle>
            </b-iconstack>
            <small class="event-time" v-if="event.actual_start && event.actual_end">
              {{ formatDatetime(event.actual_start) }} - {{ formatDatetime(event.actual_end) }}
            </small>
            <b-icon-x @click="onDelete($event, event)"></b-icon-x>
          </div>
          <small>
            {{event.title}}
          </small>
        </div>
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
        if (
          ((start_time.toFormat('yyyy-MM-dd') == this.selectedDate) || (end_time.toFormat('yyyy-MM-dd') == this.selectedDate))
          ||
          ((start_time.startOf('day') < DateTime.fromISO(this.selectedDate).startOf('day')) && (end_time.startOf('day') > DateTime.fromISO(this.selectedDate).startOf('day')))
        ) {
          // We need to fudge the end or start time, otherwise the session is no draggable if either is
          // outside the limits for the day So we aslo keep the display start and end for the UI...
          let display_end_time = end_time
          let display_start_time = start_time
          if (end_time.toFormat('yyyy-MM-dd') != this.selectedDate) {
            if (end_time.startOf('day') > DateTime.fromISO(this.selectedDate).startOf('day')) {
              display_end_time = DateTime.fromISO(this.selectedDate).endOf('day')
            } else {
              display_end_time = start_time.endOf('day')
            }
          }
          if (start_time.toFormat('yyyy-MM-dd') != this.selectedDate) {
            if (start_time.startOf('day') < DateTime.fromISO(this.selectedDate).startOf('day')) {
              display_start_time = DateTime.fromISO(this.selectedDate).startOf('day')
            } else {
              display_start_time = end_time.startOf('day')
            }
          }
          let new_event = {
            start: display_start_time.toFormat('yyyy-MM-dd HH:mm'),
            end: display_end_time.toFormat('yyyy-MM-dd HH:mm'),
            title: session.title,
            split: session.room_id,
            id: session.id,
            duration_mins: session.duration_mins,
            actual_start: start_time,
            actual_end: end_time,
            has_conflicts: session.has_conflicts
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
    hoverText(ev) {
      if (ev.actual_start && ev.actual_end) {
        return this.formatDatetime(ev.actual_start) + ' - ' + this.formatDatetime(ev.actual_end)
      } else {
        return ''
      }
    },
    conflictsForSession(e, id) {
      e.stopPropagation()
      this.$emit("show-conflicts", id);
    },
    onEventClick(event, e) {
      e.stopPropagation()
      if (event.split) {
        this.select(event.id)
        this.$emit("show-conflicts", event.id);
      }
    },
    onEventDrop ({ event, originalEvent, external }) {
      this.updateSession(event.id, event.start, event.split)
      this.$emit("show-conflicts", event.id);
    },
    onDelete(event, ev) {
      event.stopPropagation()
      this.unselect()
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
  },
  mounted() {
    this.unselect();
  }
}
</script>

<style lang="scss">
@import '../stylesheets/style.scss';

.selected-event {
  background-color: $color-secondary-2-2;
}

// .event-with-conflicts {
//   background: repeating-linear-gradient(
//     45deg,
//     $color-secondary-2-1,
//     $color-secondary-2-1 10px,
//     $color-complement-1 10px,
//     $color-complement-1 20px
//   )
// }

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
