<template>
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
      ref="dayColumn"
    >
      <!-- TODO: Need a shorter title ... -->
      <template v-slot:title="{ title, view }">
        {{title}}
      </template>
    </vue-cal>
  </div>
</template>

<script>
import VueCal from 'vue-cal'
import 'vue-cal/dist/vuecal.css'

export default {
  name: "AvailabilityTimePicker",
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
    },
    showScrollBar: {
      type: Boolean,
      default: false
    }
  },
  components: {
    VueCal
  },
  computed: {
    dayColClass() {
      let showScroll = this.showScrollBar ? '' : 'plano-col-no-bar'
      if (this.firstDay) {
        return `col-2 pr-0 plano-col ${showScroll}`
      } else {
        return `col-2 pr-0 pl-0 plano-col plano-first ${showScroll}`
      }
    }
  },
  methods: {
    scrollBarElement: function() {
      console.debug("*** GET ELEMENT")
      return this.$refs['dayColumn'].$el.getElementsByClassName('vuecal__bg')[0]
    }
  }
}
</script>

<style lang="scss">
@import '../stylesheets/style.scss';

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
  // background-color: $color-primary-1;
}

.plano-col .vuecal__arrow--prev {
  visibility: hidden;
}
.plano-col .vuecal__arrow--next {
  visibility: hidden;
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
