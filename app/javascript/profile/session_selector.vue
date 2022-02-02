<template>
  <div class="mb-3">
    <p>
      Put in instructions here ...
    </p>

    <div class="my-3">
      <session-search
        :value="filter"
        @change="onSearchChanged"
        :columns="columns"
      >
      </session-search>
    </div>

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
import { sessionAssignmentModel } from '@/store/session_assignment.store'
import SessionSearch from './session_search'

// TODO: we need to get the assignments for the current person for each session in the result set
export default {
  name: "SessionSelector",
  components: {
    InterestIndicator,
    SessionSearch
  },
  mixins: [
    personSessionMixin,
    modelMixin,
    tableMixin // covers pagination and sorting
  ],
  data() {
    return {
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
    }
  },
  methods: {
    initialFilter() {
      return {
        "op": "all",
        "queries": [
          ["open_for_interest","=",true]
        ]
      }
    },
    onSearchChanged(arg) {
      this.filter = arg
    }
  },
  mounted() {
    this.defaultFilter = this.initialFilter()
  }
}
</script>

<style>

</style>
