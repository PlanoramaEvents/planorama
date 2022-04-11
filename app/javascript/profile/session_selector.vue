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
        <p v-html="item.description"></p>
        <div v-if="item.format">
          Format: <span class="badge badge-pill badge-info mr-1">{{item.format.name}}</span><br />
        </div>
        <div v-if="item.area_list.length > 0">
          <span class="badge badge-pill badge-primary mr-1" v-for="area in item.area_list">{{area}}</span>
        </div>
        <div v-if="item.tag_list.length > 0">
          <span class="badge badge-pill badge-secondary mr-1" v-for="tag in item.tag_list">{{tag}}</span>
        </div>
        <div v-html="item.instructions_for_interest">
        </div>
      </template>
      <template #cell(id)="{ item }">
        <interest-indicator
          :session="item"
          :person_id="person.id"
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
  model: {
    prop: 'person'
  },
  props: {
    person: {
      type: Object,
      required: true
    }
  },
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
          sortable: false,
          thClass: 'interest-column'
        }
      ]
    }
  },
  methods: {
    onSearchChanged(arg) {
      this.filter = arg
    }
  }
}
</script>

<style>

.interest-column {
  width: 7em;
}

</style>
