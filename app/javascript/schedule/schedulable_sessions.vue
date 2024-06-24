<template>
  <div class="all-scheduable-session">
    <schedule-session-search :value="filter" @change="onSearchChanged"></schedule-session-search>
    <b-overlay :show="tableBusy" rounded="sm">
      <div class="all-scheduable-session-list">
        <div class="scheduable-session mb-1" v-for="session in sortedCollection" :key="session.id" draggable="true"
          @dragstart="onEventDragStart($event, session)"
          @click="onSelectEvent($event, session)"
        >
          <strong>{{session.title}}</strong>
          ({{ session.duration ? `${session.duration} min` : 'no duration' }})
        </div>
      </div>
    </b-overlay>
    <b-pagination class="d-flex" v-model="currentPage" :total-rows="totalRows" :per-page="perPage" size="sm"
      align="center"></b-pagination>
  </div>
</template>

<script>
import modelMixin from '../store/model.mixin';
import tableMixin from '../store/table.mixin';
import ScheduleSessionSearch from './schedule_session_search';

export default {
  name: "SchedulableSessions",
  components: {
    ScheduleSessionSearch
  },
  mixins: [
    modelMixin,
    tableMixin
  ],
  data: () => ({
  }),
  computed: {
  },
  methods: {
    onSearchChanged(arg) {
      this.filter = arg
    },
    onEventDragStart (e, draggable) {
      // Passing the event's data to Vue Cal through the DataTransfer object.
      e.dataTransfer.setData('event', JSON.stringify(draggable))
      e.dataTransfer.setData('cursor-grab-at', e.offsetY)
    },
    pillClass(color) {
      return `badge badge-pill mr-1 badge-${color} mr-1`
    },
    onSelectEvent(e, session) {
      this.select(session.id)
    }
  },
  mounted() {
    this.fetchPaged(false)
  }
}
</script>

<style lang="scss">
@import '../stylesheets/style.scss';

.all-scheduable-session-list {
  overflow-y: scroll;
  max-height: 200px;
  min-height: 200px;
}

.scheduable-session {
  background-color: $color-secondary-2-1; //rgba(160,220,255,.5);
  border: 1px solid rgba(0,100,150,.15);
  padding: .2em .4em;
  cursor: move;
  cursor: -webkit-grab;
  cursor: grab;
}
</style>
