<template>
  <div class="col-10">
    <div class="d-flex flex-row justify-content-between">
      <b-link @click="showPersonDetails(assignee)">{{assignee.name}}</b-link>
      <div v-if="assignment">
        Rank: {{assignment.interest_ranking}}
      </div>
      <div v-else>
        Rank: Unranked
      </div>
      <div>
        Session moderation preference: {{assignee.willing_to_moderate}}
      </div>
      <div>
        Attendance Type: {{assignee.attendance_type}}
      </div>
      <div>
        Accessibility Concerns: {{assignee.needs_accommodations}}
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

// Seacrh for people to add as participants
export default {
  name: "Assignee",
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
      console.debug("***** SHOW PERSON DETAIL", person)
      // create the assignment
    }
  }
}
</script>

<style>
</style>
