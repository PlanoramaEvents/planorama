<template>
  <div>
    <!--
    TODO:
      list of who was interested - sorted by rank (nulls comming first....)
      sidebar with the profile stuff (read only) -- use in the person sidebar eventually ...
    -->
    <div class='row mb-4'>
      <div class="col-2">
        Assignment State
      </div>
      <div class="col-10">
        Potential Participants
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
      :session="session"
      :model="personModel"
      @change="refreshAssignments"
    ></participant-search>
  </div>
</template>

<script>
import modelMixin from '../store/model.mixin';
import tableMixin from '../store/table.mixin';
import { sessionAssignmentModel } from '@/store/session_assignment.store'
import { personModel } from '@/store/person.store'
import AssignmentState from './assignment_state'
import ParticipantSearch from './participant_search'
import Assignee from './assignee'

export default {
  name: "AssignParticipants",
  components: {
    AssignmentState,
    ParticipantSearch,
    Assignee
  },
  mixins: [
    modelMixin,
    tableMixin // covers pagination and sorting
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
      sessionAssignmentModel,
      personModel
    }
  },
  computed: {
    peopleFilter() {
      let filter = {
        "op": "all",
        "queries":[
          ["subquery", "unassigned", this.session.id]
        ]
      }

      return filter
    }
  },
  methods: {
    saveAssignment(assignment) {
      this.save(assignment)
    },
    refreshAssignments(arg) {
      this.fetchPaged(false);
    }
  },
  mounted() {
    // If there is no pager we need to get the initial collection somehow
    // Order should be by created_at date and ranking ...
    this.fetchPaged(false); // false to not clear store of existing models
  }
}
</script>

<style>
</style>
