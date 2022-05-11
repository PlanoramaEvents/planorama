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
    :time-cell-height="20"
    :editable-events="{ title: false, drag: true, resize: false, delete: true, create: true }"
    class="vuecal--full-height-delete"
    ref="dayRoomGrid"
  >
    <template v-slot:title="{ title, view }">
      {{ formatDate(view.selectedDate, { weekday: 'long' }) }},
      {{ formatDate(view.selectedDate, { day: 'numeric', month: 'short' }) }}
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
    scrollBarElement: function() {
      return this.$refs['dayRoomGrid'].$el.getElementsByClassName('day-view')[0]
    },
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
  },
  mounted() {
    //do something after mounting vue instance
    // this.fetch_models(roomModel).then(data => {
    //   this.rooms = Object.values(data).filter(
    //     obj => (typeof obj.json === 'undefined')
    //   )
    // })
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
</style>
