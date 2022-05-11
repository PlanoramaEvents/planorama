<template>
  <div class="container scrollable">
    <!--
    Calendar - based on the con days
    Split - based on the con rooms
    Session to drag-n-drop (with search etc)
    -->
    <div class="row">
      <div class="col-10">
        <vue-cal
          hide-view-selector
          xsmall
          selected-date="2022-09-01"
          :split-days="roomHeading"
          :disable-views="['years', 'year', 'month', 'week']"
          :editable-events="{ title: false, drag: false, resize: false, delete: true, create: false }"
          class="vuecal--full-height-delete"
        >
          <template v-slot:title="{ title, view }">
            {{ formatDate(view.selectedDate, { weekday: 'long' }) }},
            {{ formatDate(view.selectedDate, { day: 'numeric', month: 'short' }) }}
          </template>

        </vue-cal>
      </div>
    </div>
  </div>
</template>

<script>
import VueCal from 'vue-cal'
import 'vue-cal/dist/vuecal.css'

const { DateTime } = require("luxon");

export default {
  name: "ScheduleScreen",
  components: {
    VueCal
  },
  data: () =>  ({
    // splitDays: [
    //   // The id property is added automatically if none (starting from 1), but you can set a custom one.
    //   // If you need to toggle the splits, you must set the id explicitly.
    //   { id: 1, class: 'room-col', label: 'Mom' },
    //   { id: 2, class: 'room-col', label: 'Dad'},
    //   { id: 3, class: 'room-col', label: 'Kid 1' },
    //   { id: 4, class: 'room-col', label: 'Kid 2' },
    //   { id: 5, class: 'room-col', label: 'Kid 3' }
    // ]
  }),
  computed: {
    roomHeading() {
      // return this.configByName('email_reply_to_address')
      return [
        // The id property is added automatically if none (starting from 1), but you can set a custom one.
        // If you need to toggle the splits, you must set the id explicitly.
        { id: 1, class: 'room-col', label: 'Mom' },
        { id: 2, class: 'room-col', label: 'Dad'},
        { id: 3, class: 'room-col', label: 'Kid 1' },
        { id: 4, class: 'room-col', label: 'Kid 2' },
        { id: 5, class: 'room-col', label: 'Kid 3' }
      ]
    },
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
  }
}
</script>

<style lang="scss">
@import '../stylesheets/style.scss';


.vuecal__arrow--prev,
.vuecal__arrow--prev {
  display: none;
}

.vuecal__arrow--next,
.vuecal__arrow--next {
  display: none;
}

.vuecal__cell .room-col:nth-of-type(odd){
  background: rgba(0, 0, 0, 0.05);
}
</style>
