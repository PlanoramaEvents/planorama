<template>
  <div class="availability-conflicts">
    <div class="availability-conflicts-list">
      <div
        class="availability-conflict mb-1"
        v-for="conflict in sortedCollection" :key="conflict.id"
      >
        <strong>{{conflict.session.title}}</strong>
        <p>
          {{conflict.person.published_name}} is not  available
        </p>
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
</style>
