<template>
  <div class="mb-3">
    <p>
      Aby zawęzić wyświetlane sesje, filtruj według obszaru lub przeprowadź wyszukiwanie po słowach (lub oba!) klikając przycisk wyszukiwania.<br />
      Wybierz sesje, w których chcesz uczestniczyć, używając suwaka po prawej stronie opisu.
      Twoje wybory pojawią się na karcie Ranking Sesji.
    </p>

    <session-search
      :value="filter"
      @change="onSearchChanged"
      :columns="columns"
      :personId="person.id"
    >
    </session-search>

    <b-pagination class="d-flex justify-content-end"
      v-model="currentPage"
      :total-rows="totalRows"
      :per-page="perPage"
      first-text="Pierwsza"
      last-text="Ostatnia"
      prev-text="Poprzednia"
      next-text="Następna"
    ></b-pagination>

    <b-overlay :show="loading" rounded="sm">
      <div class="container">
        <div class='row mb-2'>
          <div class="col-11">
          </div>
          <div class="col-1">
            <b>Dodaj do zainteresowanych</b>
          </div>
        </div>
        <div class='row mb-5' v-for="item in sortedCollection" :key="item.id">
          <div class="col-11">
            <h4>{{ item.title }}</h4>
            <div v-html="item.description"></div>
            <div v-if="item.format">
              Format: <span class="badge badge-pill badge-info mr-1">{{ item.format.name }}</span><br />
            </div>
            <div v-if="item.area_list.length > 0">
              Obszar(y): <span class="badge badge-pill badge-primary mr-1" v-for="area in item.area_list" :key="area">{{ area }}</span>
            </div>
            <div v-if="item.tag_list.length > 0">
              Tag(i): <span class="badge badge-pill badge-warning mr-1" v-for="tag in item.tag_list" :key="tag">{{ tagFormatter(tag) }}</span>
            </div>
            <div class="mt-3" v-if="item.instructions_for_interest">Instrukcje dla potencjalnych panelistów:</div>
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
      </div>
    </b-overlay>

    <b-pagination class="d-flex justify-content-end"
      v-model="currentPage"
      :total-rows="totalRows"
      :per-page="perPage"
      first-text="Pierwsza"
      last-text="Ostatnia"
      prev-text="Poprzednia"
      next-text="Następna"
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
import { tagsMixin } from '@/store/tags.mixin';
import { personModel } from '@/store/person.store'

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
    tableMixin, // covers pagination and sorting
    tagsMixin,
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
          label: 'Dodaj do zainteresowanych',
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
    this.fetchPaged()
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
