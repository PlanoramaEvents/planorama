<template>
  <div class="col-10">
    <div class="d-flex flex-row justify-content-between">
      <b-link @click="showPersonDetails(assignee)" class="mr-2">{{assignee.published_name}}</b-link>
      <div class="mr-2">
        Rank: {{rank}}
      </div>
      <div class="mr-2">
        Default moderation preference: {{defaultModPreference}}
      </div>
      <div class="mr-2">
        Session moderation preference: {{sessionModPreference}}
      </div>
      <div class="mr-2">
        Attendance Type: {{assignee.attendance_type}}
      </div>
      <div class="mr-2">
        Accessibility Concerns: {{assignee.needs_accommodations ? 'Y' : 'N'}}
      </div>
    </div>
    <div class="mt-2">
      Session Comments
      <div class="ml-5" v-if="assignment">
        {{assignment.interest_notes}}
      </div>
    </div>
    <div class="mt-2">
      Other Demographic concerns
      <div class="ml-5">
        {{assignee.demographic_categories}}
      </div>
    </div>
  </div>
</template>

<script>
import modelUtilsMixin from "@/store/model_utils.mixin";

// Seacrh for people to add as participants
export default {
  name: "Assignee",
  mixins: [modelUtilsMixin],
  props: {
    assignment: {
      type: Object,
      required: false
    },
    person: {
      type: Object,
      required: false
    }
  },
  computed: {
    rank() {
      if (this.assignment) {
        if (this.assignment.interest_ranking) {
          return this.assignment.interest_ranking
        }
      }
      return 'Unranked'
    },
    defaultModPreference() {
      if (this.assignee.willing_to_moderate) return 'Y'
      return 'N'
    },
    sessionModPreference() {
      if (this.assignment) {
        if (this.assignment.interest_role == 'can_moderate') {
          return "Y"
        } else if (this.assignment.interest_role == 'not_moderate') {
          return "N"
        }
      }
      // {{assignment.interest_role}}
      return "default"
    },
    assignee() {
      let p = this.person

      if (this.assignment) {
        p = this.assignment.person
      }

      return p
    }
  },
  methods: {
    showPersonDetails(person) {
      // We need the assignment AND the person selected
      this.select_model('session_assignment', null)
      if (this.assignment) this.select_model('session_assignment', this.assignment);
      this.select_model('person', person);
    }
  }
}
</script>

<style>
</style>
