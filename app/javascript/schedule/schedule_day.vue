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
    :time-cell-height="40"
    :editable-events="{ title: false, drag: true, resize: false, delete: false, create: false }"
    class="vuecal--full-height-delete"
    ref="dayRoomGrid"
    :events="events"
    @event-drop="onEventDrop"
  >
    <template v-slot:title="{ title, view }">
      {{ formatDate(view.selectedDate, { weekday: 'long' }) }},
      {{ formatDate(view.selectedDate, { day: 'numeric', month: 'short' }) }}
    </template>
    <template v-slot:event="{ event, view }">
      <div class="d-flex flex-column">
        <div class="d-flex flex-row p-1">
          <small class="event-time">
            {{ formatLocaleDate(event.start) }} - {{ formatDatetime(addMinutes(event.start, event.duration_mins)) }}
          </small>
          <b-icon-trash @click="onDelete(event)" class="ml-auto mt-1"></b-icon-trash>
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

export default {
  name: "ScheduleDay",
  components: {
    VueCal
  },
  mixins: [
    dateTimeMixin
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
    }
  },
  data: () =>  ({
    events: []
  }),
  computed: {
    roomHeading() {
      if (this.rooms) {
        let headings = this.rooms.map(
          obj => (
            {
              id: obj.id,
              class: 'room-col',
              label: obj.name
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
    // onCreate(ev) {
    //   // console.debug("******** 1. CREATE EVENT", ev)
    // },
    onEventDrop ({ event, originalEvent, external }) {
      let eventDuration = event.duration_mins
      let startTimeMinutes = event.startTimeMinutes
      event.endTimeMinutes = Math.min(startTimeMinutes + eventDuration, 24 * 60)
      event.end = new Date(event.start.getTime() + event.duration_mins*60000); //event.start + event.duration_mins
      // TODO: use ev.id to set the start time and room

      // Hack for the display size
      let mevs = this.$refs['dayRoomGrid'].mutableEvents.filter(e => e._eid == event._eid)
      mevs[0].endTimeMinutes = event.endTimeMinutes
      mevs[0].end = event.end
    },
    onDelete(ev) {
      let cid = ev._eid
      console.debug("******** 1. DELETE EVENT", ev._eid, ev.id)
      // TODO: use ev.id to remove the start time for the session
      this.$refs['dayRoomGrid'].mutableEvents = this.$refs['dayRoomGrid'].mutableEvents.filter(
        (e) => e._eid != cid
      )
      this.$refs['dayRoomGrid'].view.events = this.$refs['dayRoomGrid'].view.events.filter(
        (e) => e._eid != cid
      )
    },
    scrollBarElement: function() {
      return this.$refs['dayRoomGrid'].$el.getElementsByClassName('day-view')[0]
    },
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
</style>
