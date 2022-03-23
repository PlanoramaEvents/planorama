<template>
  <!-- pr-0 if first day otherwise p-1 -->
  <div v-bind:class="dayColClass">
    <vue-cal
      hide-view-selector
      xsmall
      active-view="day"
      style="height: 30em;"
      :editable-events="{ title: false, drag: true, resize: true, delete: true, create: true }"
      :disable-views="['years', 'year', 'month', 'week']"
      :time-cell-height="18"
      :time-from="startTime * 60"
      :time-step="timeStep"
      :snap-to-time="timeStep"
      :min-date="day"
      :max-date="day"
      :selected-date="day"
      ref="day1"
    >
      <template v-slot:title="{ title, view }">
        {{title}}
      </template>
    </vue-cal>
  </div>
    <!-- <div class="col-2 m-0 p-0">
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
      </vue-cal>
    </div> -->
</template>

<script>
import VueCal from 'vue-cal'
import 'vue-cal/dist/vuecal.css'

// vuecal__body

export default {
  name: "AvailabilityTimePicker",
  // :time-from="5 * 60"
  // :time-step="30"
  // :snap-to-time="30"
  // min-date="2022-09-01"
  // max-date="2022-09-01"
  // selected-date="2022-09-01"
  props: {
    startTime: {
      type: Number,
      default: 6
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
    }
  },
  data: () => ({
    // startTime: 6,
    // timeStep: 30,
    // snapToTime: 30,
    // day:
    // minDate: "2022-09-01",
    // maxDate: "2022-09-05"
  }),
  components: {
    VueCal
  },
  computed: {
    dayColClass() {
      if (this.firstDay) {
        return "col-2 m-0 pr-0"
      } else {
        return "col-2 m-0 p-0 plano-first"
      }
    }
  },
  methods: {
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

.plano-first .vuecal__time-column,
.plano-first .vuecal__time-cell {
  width: 0px
}

.plano-first .vuecal__time-cell-label {
  display: none;
}
</style>
