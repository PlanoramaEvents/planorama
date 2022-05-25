<template>
  <div class="all-scheduable-session">
    <!-- TODO: add pager ... -->
    <!-- TODO: add search/filter ... -->
    <schedule-session-search
      :value="filter"
      @change="onSearchChanged"
    ></schedule-session-search>
    <div class="all-scheduable-session-list">
      <div
        class="scheduable-session mb-1"
        v-for="session in sortedCollection" :key="session.id"
        draggable="true"
        @dragstart="onEventDragStart($event, session)"
      >
        <strong>{{session.title}}</strong>
        ({{ session.duration ? `${session.duration} min` : 'no duration' }})
      </div>
    </div>
    <b-pagination class="d-flex"
      v-model="currentPage"
      :total-rows="totalRows"
      :per-page="perPage"
      size="sm"
      align="center"
    ></b-pagination>
  </div>
</template>

<script>
import modelMixin from '../store/model.mixin';
import tableMixin from '../store/table.mixin';
// import { sessionModel as model } from '@/store/session.store'
import ScheduleSessionSearch from './schedule_session_search';

// TODO: filter out sessions with no duration
export default {
  name: "SchedulableSessions",
  components: {
    ScheduleSessionSearch
  },
  mixins: [
    // modelUtilsMixin,
    modelMixin,
    tableMixin
  ],
  props: {
    // TODO: add filter
  },
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
    init: function() {
      this.fetchPaged(false)
    },
  },
  mounted() {
    //do something after mounting vue instance
    // this.fetch_models(roomModel).then(data => {
    //   this.rooms = Object.values(data).filter(
    //     obj => (typeof obj.json === 'undefined')
    //   )
    this.init()
    // })
  }
}
</script>

<style lang="scss">
@import '../stylesheets/style.scss';


.all-scheduable-session-list {
  overflow-y: scroll;
  max-height: 200px;
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
