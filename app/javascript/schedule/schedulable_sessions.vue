<template>
  <div class="all-scheduable-session">
    <!-- TODO: add pager ... -->
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
</template>

<script>
import modelMixin from '../store/model.mixin';
import tableMixin from '../store/table.mixin';
import { sessionModel as model } from '@/store/session.store'

export default {
  name: "SchedulableSessions",
  components: {
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
    onEventDragStart (e, draggable) {
      // Passing the event's data to Vue Cal through the DataTransfer object.
      e.dataTransfer.setData('event', JSON.stringify(draggable))
      e.dataTransfer.setData('cursor-grab-at', e.offsetY)
    },
    init: function() {
      this.fetchPaged()
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

.all-scheduable-session {
  overflow-y: scroll;
  // height: 600px;
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
