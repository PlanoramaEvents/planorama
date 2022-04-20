<template>
  <div>
    <!--
    TODO:

      list of who was interested - sorted by rank DONE
      search for people (excluding those interested already)
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
      <div class="col-10">
        <div class="d-flex flex-row justify-content-between">
          <b-link @click="showPersonDetails(item.person)">{{item.person.name}}</b-link>
          <div>
            Rank: {{item.interest_ranking}}
          </div>
          <div>
            Session moderation preference: {{item.person.willing_to_moderate}}
          </div>
          <div>
            Attendance Type: {{item.person.attendance_type}}
          </div>
          <div>
            Accessibility Concerns: {{item.person.needs_accommodations}}
          </div>
        </div>
        <div class="mt-2">
          Session Comments
          <div class="ml-5">
            {{item.interest_notes}}
          </div>
        </div>
        <div class="mt-2">
          Other Demographic concerns
          <div class="ml-5">
            {{item.person.demographic_categories}}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import modelMixin from '../store/model.mixin';
import tableMixin from '../store/table.mixin';
import { sessionAssignmentModel } from '@/store/session_assignment.store'
import AssignmentState from './assignment_state'

export default {
  name: "AssignParticipants",
  components: {
    AssignmentState
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
      columns : [
        {
          key: 'id',
          label: '',
          sortable: false,
          thClass: 'action-column'
        },
        {
          key: 'title',
          label: ' ',
          sortable: false
        }
      ]
    }
  },
  methods: {
    saveAssignment(assignment) {
      console.debug("***** Save the Assignment", assignment)
      this.save(assignment)
    },
    showPersonDetails(person) {
      console.debug("***** SHOW PERSON DETAIL", person)
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
