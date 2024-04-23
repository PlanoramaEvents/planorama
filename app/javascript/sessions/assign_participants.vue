<template>
  <div class="container-fluid">
    <div class='row mb-4' v-if="sortedCollection.length == 0">
      <div class="col-12">
        <h5>Nikt z uczestników nie wyraził zainteresowania tą sesją</h5>
      </div>
    </div>
    <div class='row mb-4' v-if="sortedCollection.length > 0">
      <div class="col-3">
        <span>
          Stan Przypisania
          <button @click="reorder" class="btn btn-primary btn-sm">Zmień kolejność</button>
        </span>
      </div>
      <div class="col-9">
        Potencjalni Uczestnicy
      </div>
    </div>
    <div class='row mb-4' v-for="item in sortedCollection" :key="item.id">
      <div class="col-2">
        <assignment-state
          :session-assignment="item"
          @input="saveAssignment"
        ></assignment-state>
      </div>
      <assignee :assignment="item"></assignee>
    </div>

    <participant-search
      :defaultFilter="peopleFilter"
      defaultSortBy="people.published_name"
      :session="session"
      :model="personModel"
      @change="refreshAssignments"
      class="border-top border-dark pt-3"
    ></participant-search>

    <person-details model="person"></person-details>
  </div>
</template>

<script>
import { modelMixin } from '@/store/model.mixin';
import modelUtilsMixin from "@/store/model_utils.mixin";
import tableMixin from '../store/table.mixin';
import { sessionAssignmentModel } from '@/store/session_assignment.store'
import { personModel } from '@/store/person.store'
import AssignmentState from './assignment_state'
import ParticipantSearch from './participant_search'
import Assignee from './assignee'
import PersonDetails from './person_details'
import { sessionModel } from '@/store/session.store';

export default {
  name: "AssignParticipants",
  components: {
    AssignmentState,
    ParticipantSearch,
    Assignee,
    PersonDetails
  },
  mixins: [
    modelMixin,
    modelUtilsMixin,
    tableMixin, // covers pagination and sorting
  ],
  data() {
    return {
      sessionAssignmentModel,
      personModel
    }
  },
  computed: {
    session() {
      return this.selected_model(sessionModel);
    },
    peopleFilter() {
      // NOTE: sessionAssignmentModel
      let filter = {
        "op": "all",
        "queries":[
          ["subquery", "unassigned", this.session.id],
          ["con_state", "!=", "declined"],
          ["con_state", "!=", "rejected"]
        ]
      }

      return JSON.stringify(filter)
    }
  },
  methods: {
    reorder() {
      this.fetchAll(false)
    },
    saveAssignment(assignment) {
      this.save(assignment).then(
        () => {
          // TODO?
          // this.refreshSession()
          this.fetchAll(false)
        }
      ).catch(
        () => {
          // this.refreshSession()
          this.fetchAll(false)
        }
      )
    },
    refreshAssignments(arg) {
      this.fetchAll(false).then(
        () => {
          this.refreshSession()
        }
      )
    },
    refreshSession() {
      this.fetch_model_by_id('session',this.session.id);
    }
  },
  mounted() {
    // If there is no pager we need to get the initial collection somehow
    // Order should be by created_at date and ranking ...
    this.fetchAll(false); // false to not clear store of existing models
    this.select_model('session_assignment', null)
    this.select_model('person', null);
  }
}
</script>

<style>
</style>
