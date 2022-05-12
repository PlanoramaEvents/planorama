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
    :editable-events="{ title: false, drag: true, resize: false, delete: true, create: true }"
    class="vuecal--full-height-delete"
    ref="dayRoomGrid"
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
            {{ formatLocaleDate(event.start) }} - {{ formatLocaleDate(event.end) }}
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

// import modelUtilsMixin from "@/store/model_utils.mixin";
// import { roomModel } from '../store/room.store.js';

const { DateTime } = require("luxon");

export default {
  name: "ScheduleDay",
  components: {
    VueCal
  },
  mixins: [
    // modelUtilsMixin
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
    }
  },
  data: () =>  ({
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
    onEventDrop ({ event, originalEvent, external }) {
      console.debug("******** 1. DROP EVENT", originalEvent._eid, originalEvent.id)
      // TODO: use originalEvent.id to set the start time for the session
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
    formatLocaleDate(date) {
      let res = DateTime.fromJSDate(date).toLocaleString(DateTime.TIME_SIMPLE)
      return res
    },
    formatDate(date, config) {
      // TODO: use the users locale or browsers locale here
      return date.toLocaleString('en-US',config)
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
  },
  // mounted() {
  // }
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
  background-color: $color-secondary-2-1; //$color-secondary-1-1;
}

.vuecal__arrow--prev,
.vuecal__arrow--prev {
  display: none;
}

.vuecal__arrow--next,
.vuecal__arrow--next {
  display: none;
}

.vuecal__cell .room-col:nth-of-type(odd){
  background: $color-light-blue; //rgba(0, 0, 0, 0.05);
}

.event-time {
  font-size: smaller;
}
</style>
