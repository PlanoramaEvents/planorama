<template>
  <div :id="id">
    <div class="main-line"></div>
    <div class="stations" role="radiogroup" :aria-label="ariaLabel">
      <div
        :id="stepId(i)"
        :class="{ station: true, selected: selected === stop }"
        v-for="(stop, i) of stops"
        :key="i"
        :style="{ '--extra-len': (9 - stops.length) / 2 + 1 + 'rem' }"
        :tabindex="selected !== undefined ? (stop === selected ? 0 : -1) : i === 0 ? 0 : -1"
        :aria-label="'Step ' + (i + 1) + ': ' + stop"
        role="radio"
        @click="select(i)"
        @keyup.space="select(i)"
        @keyup.right="select(i+1)"
        @keyup.down="select(i+1)"
        @keyup.left="select(i-1)"
        @keyup.up="select(i-1)"
      >
        <div class="stop">{{ i + 1 }}</div>
        <div class="name">{{ stop }}</div>
      </div>
    </div>
  </div>
</template>

<script>
/**
 * Note: this is best used in a container with a min-width of at least 50rem.
 * Do otherwise at your own peril.
 */
export default {
  name: "Stepper2",
  props: {
    steps: {
      type: Array,
      required: true,
    },
    value: {},
    ariaLabel: {
      type: String,
      default: "Select a step",
    },
    id: {
      type: String,
      default: "stepper2"
    }
  },
  data: () => ({
    noVmodel: undefined
  }),
  computed: {
    selected() {
      return this.value ?? this.noVmodel ?? this.stops[0];
    },
    stops() {
      return this.steps;
    }
  },
  methods: {
    select(i) {
      // first check to see if i is in range, and if it's not, wrap
      if (i < 0) {
        this.select(this.stops.length - 1);
      } else if (i >= this.stops.length) {
        this.select(0);
      } else {
        // actually select the thing
        this.noVmodel = this.stops[i]
        document.getElementById(this.stepId(i)).focus();
        this.$emit('input', this.stops[i]);
        this.$emit('change', this.stops[i]);
      }
    },
    stepId(i) {
      return `${this.id}-step-${i}`
    }
  }
};
</script>

<style lang="scss" scoped>
.main-line {
  border: 5px solid #53269f;
  border-radius: 5px;
  min-width: 43rem;
}

.station .stop {
  display: inline-block;
  font-weight: 700;
  font-size: 1.5rem;
  font-family: Arial, Helvetica, sans-serif;
  text-align: center;
  position: relative;
  top: -1.375rem;
  z-index: 1;
  color: #53269f;
  margin-left: var(--extra-len);
}

.station.selected .stop {
  font-size: 2rem;
  top: -1.75rem;
  color: white;
}

.stations {
  display: flex;
  justify-content: space-evenly;
}

.station .stop:after {
  content: "";
  display: block;
  border: 4px solid #53269f;
  background: white;
  border-radius: 50%;
  height: 2.25rem;
  width: 2.25rem;
  position: relative;
  top: -2.15rem;
  z-index: -1;
}

.station .name {
  width: calc(2.25rem + 2 * var(--extra-len));
  position: relative;
  text-align: center;
  top: -2rem;
  text-overflow: ellipsis;
  word-break: none;
  overflow: hidden;
  overflow-wrap: break-word;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 3;
  hyphens: auto;
}

.station.selected .name {
  width: calc(3rem + 2 * var(--extra-len));
  top: -3.5rem;
}

.station.selected .stop:after {
  height: 3rem;
  width: 3rem;
  top: -2.9rem;
  background-color: #53269f;
}

.station {
  cursor: pointer;
}
</style>
