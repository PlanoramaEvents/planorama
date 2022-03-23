<template>
  <div class="row">
    <div class="col-2 m-0 pr-0">
      <vue-cal
        hide-view-selector
        active-view="day"
        :disable-views="['years', 'year', 'month', 'week']"
        min-date="2022-09-01"
        max-date="2022-09-01"
        selected-date="2022-09-01"
        style="height: 30em;"
        :time-from="5 * 60"
        :time-cell-height="18"
        :time-step="30"
        :on-event-click="onEventClick"
        xsmall
        :editable-events="{ title: false, drag: true, resize: true, delete: true, create: true }"
        :snap-to-time="30"
        ref="day1"
      >
        <template v-slot:title="{ title, view }">
          {{title}}
        </template>
      </vue-cal>
    </div>
    <div class="col-2 m-0 p-0">
      <vue-cal
        hide-view-selector
        active-view="day"
        :disable-views="['years', 'year', 'month', 'week']"
        min-date="2022-09-02"
        max-date="2022-09-02"
        selected-date="2022-09-02"
        style="height: 30em;"
        :time-from="5 * 60"
        :time-cell-height="18"
        :time-step="30"
        xsmall
        :editable-events="{ title: false, drag: false, resize: true, delete: true, create: true }"
        :snap-to-time="30"
        @ready="onReady"
        ref="day2"
      >
        <template v-slot:title>
          2022-09-02
        </template>
        <!-- <template v-slot:time-cell="{ hours, minutes }">
          <div :class="{ 'vuecal__time-cell-line': true, hours: !minutes }">
            <strong v-if="!minutes" style="font-size: 12px">{{ hours }}</strong>
          </div>
        </template> -->
      </vue-cal>
    </div>
  </div>
</template>

<script>
import VueCal from 'vue-cal'
import 'vue-cal/dist/vuecal.css'

// vuecal__body

export default {
  name: "AvailabilityCalendar",
  data: () => ({
    // minDate: "2022-09-01",
    // maxDate: "2022-09-05"
  }),
  components: {
    VueCal
  },
  methods: {
    onEventClick (event, e) {
      // Prevent navigating to narrower view (default vue-cal behavior).
      e.stopPropagation()
    },
    onReady: function(arg) {
      let el = this.$refs['day2'].$el.getElementsByClassName('vuecal__bg')
      this.day2 = this.$refs['day2'].$el.getElementsByClassName('vuecal__bg')[0]
      // console.debug("**** READY ", el[0])
      el[0].addEventListener("scroll", this.syncScroll) //function() { console.debug('**** FCK')}) //.onscroll = this.syncScroll
      this.day1 = this.$refs['day1'].$el.getElementsByClassName('vuecal__bg')[0]
    },
    syncScroll: function(arg) {
      console.debug("**** SYNC", arg)
      this.day1.scrollTop = this.day2.scrollTop
    }
  }
}
</script>

<style>
.vuecal__arrow--prev {
  visibility: hidden;
}
.vuecal__arrow--next {
  visibility: hidden;
}
/* .vuecal__time-cell-line.hours:before {border-color: #42b983;} */

/* .vuecal__time-column,
.vuecal__time-cell {
  width: 0px
}

.vuecal__time-cell-label {
  display: none;
} */
</style>
