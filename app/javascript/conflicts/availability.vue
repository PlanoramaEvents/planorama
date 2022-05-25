<template>
  <div class="availability-conflicts">
    <div class="availability-conflicts-list">
      <div
        class="availability-conflict mb-1"
        v-for="conflict in sortedCollection" :key="conflict.id"
      >
        <strong>{{conflict.title}}</strong>
        <div><em>Outside the availability for:</em></div>
        <div v-for="availability in conflict.availability_conflicts" :key="availability.id">
          {{availability.person.published_name}}
        </div>
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
// import { availabilityConflictModel as model } from '@/store/availability_conflict.store'

export default {
  name: "Availability",
  mixins: [
    modelMixin,
    tableMixin
  ],
  props: {
  },
  components: {
  },
  data: () =>  ({
  }),
  methods: {
    init: function() {
      this.fetchPaged()
    }
  },
  mounted() {
    this.init()
  }
}
</script>

<style lang="scss">
.availability-conflicts-list {
  overflow-y: scroll;
  max-height: 300px;
}

.availability-conflict {
  border: 1px solid rgba(0,100,150,.15);
  padding: .2em .4em;
}
</style>
