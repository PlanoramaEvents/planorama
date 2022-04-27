<template>
  <div class="mb-3">
    <p>
      To refine the sessions displayed, filter by area or do a word search (or both!) by clicking on the search button.<br />
      Select sessions you are interested in being on by using the slider to the right of the description.
      Your selections will appear on the Sessions Ranking tab.
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

    <b-overlay :show="loading" rounded="sm">
      <div class='row mb-2'>
        <div class="col-11">
        </div>
        <div class="col-1">
          <b>Add to Interested</b>
        </div>
      </div>
      <div class='row mb-5' v-for="item in sortedCollection">
        <div class="col-11">
          <h4>{{item.title}}</h4>
          <div v-html="item.description"></div>
          <div v-if="item.format">
            Format: <span class="badge badge-pill badge-info mr-1">{{item.format.name}}</span><br />
          </div>
          <div v-if="item.area_list.length > 0">
            Area(s): <span class="badge badge-pill badge-primary mr-1" v-for="area in item.area_list" :key="area">{{area}}</span>
          </div>
          <div v-if="item.tag_list.length > 0">
            Tag(s): <span class="badge badge-pill badge-secondary mr-1" v-for="tag in item.tag_list" :key="tag">{{tag}}</span>
          </div>
          <div class="mt-3" v-if="item.instructions_for_interest">Instructions for potential panelists:</div>
          <div class="panelist-instructions" v-html="item.instructions_for_interest">
          </div>
        </div>
        <div class="col-1">
          <div v-if="assignments">
            <interest-indicator
              :session="item"
              :person_id="person.id"
              :model="sessionAssignmentModel"
              :assignments="assignments"
            ></interest-indicator>
          </div>
        </div>
      </div>
    </b-overlay>

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
import modelUtilsMixin from '../store/model_utils.mixin';
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
    modelUtilsMixin,
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
      ],
      assignments : null,
      loading: true
    }
  },
  methods: {
    onSearchChanged(arg) {
      this.filter = arg
    }
  },
  mounted() {
    // Ensure we have fetched our assignments
    this.fetch_models(
      sessionAssignmentModel,
      {
        filter: `{"op":"all","queries":[["person_id", "=", "${this.person.id}"]]}`
      }
    ).then(data => {
      this.assignments = Object.values(data)
      this.loading = false
    })
  }
}
</script>

<style>

.interest-column {
  width: 7em;
}

.panelist-instructions {
  font-style: italic;
}

</style>
