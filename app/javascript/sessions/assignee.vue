<template>
  <div class="col-10">
    <div class="d-flex flex-row justify-content-between">
      <b-link @click="showPersonDetails(assignee)" class="mr-2">{{assignee.published_name}}</b-link>
      <div class="mr-2">
        Rank: <em>{{rank}}</em>
      </div>
      <div class="mr-2">
        Default moderation preference: <span class="first-capital"><em>{{defaultModPreference}}</em></span>
      </div>
      <div class="mr-2">
        Session moderation preference: <span class="first-capital"><em>{{sessionModPreference}}</em></span>
      </div>
      <div class="mr-2">
        Attendance type: <em>{{assignee.attendance_type | capitalize | na_if_empty}}</em>
      </div>
      <div class="mr-2">
        Accessibility concerns: <em>{{assignee.needs_accommodations ? 'Y' : 'N'}}</em>
      </div>
    </div>
    <div class="mt-2">
      <div v-if="noInterestExpressed"><em>Did not express interest</em></div>
      <div>Status: <em>{{assignee.con_state}}</em></div>
      <h6>Session comments</h6>
      <div class="ml-2 keep-format" v-if="assignment">{{assignment.interest_notes | na_if_empty}}</div>
      <div class="ml-2" v-else>N/A</div>
    </div>
    <div class="mt-2" v-if="!isHidden('demographic_categories')">
      <h6>Other demographic categories</h6>
      <div class="ml-2">
        {{assignee.demographic_categories | na_if_empty}}
      </div>
    </div>
  </div>
</template>

<script>
import modelUtilsMixin from "@/store/model_utils.mixin";
import { peopleHiddenFieldsMixin } from '@/configurations/people_hidden_fields.mixin';

// Seacrh for people to add as participants
export default {
  name: "Assignee",
  mixins: [modelUtilsMixin, peopleHiddenFieldsMixin],
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
    noInterestExpressed() {
      if (this.assignment) {
        return !this.assignment.interested
      } else {
        return true
      }
    },
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
