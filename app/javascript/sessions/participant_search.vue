<template>
  <div class="container">
    <h5>Uczestnicy Dodatkowi</h5>
    <search-vue
      id="session-search-field" 
      class="w-75 mt-3"
      :value="filter"
      @change="onSearchChanged"
      :columns="columns"
    >
    </search-vue>

    <b-pagination class="d-flex justify-content-end"
      v-model="currentPage"
      :total-rows="totalRows"
      :per-page="perPage"
      first-text="Pierwsza"
      last-text="Ostatnia"
      prev-text="Poprzednia"
      next-text="Następna"
    ></b-pagination>

    <div class='row mb-4' v-for="item in sortedCollection" :key="item.id">
      <div class="col-2">
        <b-button variant="primary" @click="addToASession(item)">Dodaj do Sesji</b-button>
      </div>
      <assignee :person="item"></assignee>
    </div>

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
import SearchVue from '../components/search_vue'
import modelMixin from '../store/model.mixin';
import tableMixin from '../store/table.mixin';
import { sessionAssignmentModel } from '@/store/session_assignment.store'
import { personModel } from '@/store/person.store'
import Assignee from './assignee'
import { people_columns as columns } from '../people/people';
import sessionAssignmentMixin from '../sessions/session_assignment.mixin';


// Seacrh for people to add as participants
export default {
  name: "ParticipantSearch",
  components: {
    Assignee,
    SearchVue
  },
  mixins: [
    modelMixin,
    tableMixin, // covers pagination and sorting
    sessionAssignmentMixin
  ],
  model: {
    prop: 'session'
  },
  props: {
    session: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      columns
    }
  },
  methods: {
    // We need to not clear on search ....
    // fetchPaged(false)
    onSearchChanged(arg) {
      this.filter = arg
    },
    addToASession(arg) {
      // remove from display and add to the session
      this.removeFromCollection(arg.id)

      this.newSessionAssignment({session: this.session, person_id: arg.id}).then(
        (obj) => {
          this.$emit('change', arg)
        }
      )
    }
  },
  mounted() {
    // If there is no pager we need to get the initial collection somehow
    // Order should be by created_at date and ranking ...
    // this.fetchPaged(false); // false to not clear store of existing models
    this.shall_clear = false
  }
}
</script>

<style>
</style>
