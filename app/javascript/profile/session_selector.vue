<template>
  <div class="mb-3">
    <p>
      Put in instructions here ...
    </p>

    <!-- TODO: search  -->
    <b-pagination class="d-flex justify-content-end"
      v-model="currentPage"
      :total-rows="totalRows"
      :per-page="perPage"
      first-text="First"
      last-text="Last"
      prev-text="Prev"
      next-text="Next"
    ></b-pagination>

    <b-table
      hover responsive small striped
      :fields="columns"
      :items="sortedCollection"
      :sort-by="sortBy"
      :no-local-sorting="true"
  >
      <template #cell(title)="{ item }">
        <h4>{{item.title}}</h4>
        <p>{{item.description}}</p>
      </template>
      <template #cell(id)="{ item }">
        <interest-indicator
          :session="item"
          :person_id="currentUser.id"
          :model="sessionAssignmentModel"
        ></interest-indicator>
      </template>
    </b-table>

    <b-pagination class="d-flex justify-content-end"
      v-model="currentPage"
      :total-rows="totalRows"
      :per-page="perPage"
      first-text="First"
      last-text="Last"
      prev-text="Prev"
      next-text="Next"
    ></b-pagination>
  </div>
</template>

<script>
import modelMixin from '../store/model.mixin';
import tableMixin from '../store/table.mixin';
import personSessionMixin from '../auth/person_session.mixin';
import InterestIndicator from './interest_indicator.vue'
// import { sessionModel as model } from '@/store/session.store'
import { sessionAssignmentModel } from '@/store/session_assignment.store'

// TODO: we need a filter applied to the sessions (only ones ready for selection)
// TODO: we need the area added and the search capability
// TODO: we need to get the assignments for the current person for each session in the result set
// TODO: we need a selector to create/edit the person's assignments
export default {
  name: "SessionSelector",
  components: {
    InterestIndicator
  },
  mixins: [
    personSessionMixin,
    modelMixin,
    tableMixin // covers pagination and sorting
  ],
  data: () => ({
    sessionAssignmentModel,
    columns : [
      {
        key: 'title',
        label: ' ',
        sortable: false
      },
      {
        key: 'id',
        label: 'Add to Interested',
        sortable: false
      }
    ]
  }),
  mounted() {
    // console.debug('MOUNT SELECTOR', this.value.id)
    this.sortBy = 'title'
  }
}
</script>

<style>

</style>
