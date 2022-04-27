<template>
  <sidebar-vue width="60%" model="person">
    <template #header v-if="selected">
      <div class="d-flex align-items-baseline">
        <h3 class="mr-auto">{{selected.published_name}}</h3>
        <div class="ml-3">Rank: {{rank}}</div>
        <div class="ml-3">Session moderation preference: <span class="first-capital">{{sessionModPreference}}</span></div>
      </div>
    </template>
    <template #content v-if="selected">
      <div>
        <div class="mt-2">
          <dl>
            <dt>Session Comments:</dt>
            <dd class='ml-2 keep-format'>{{sessionComments}}</dd>
            <dt>Bio:</dt>
            <dd class='ml-2'>
              <span v-html="selected.bio" v-if="selected.bio"></span>
              <span v-else>N/A</span>
            </dd>
          </dl>
        </div>
        <div class="d-flex flex-row mt-3">
          <div class="w-50 mr-2">
            <h5>Demographics</h5>
            <dl>
              <dt>Ethnicity:</dt>
              <dd class="ml-2">{{selected.ethnicity | na_if_empty}}</dd>
              <dt>Gender:</dt>
              <dd class="ml-2">{{selected.gender | na_if_empty}}</dd>
              <dt>Age at time of Event:</dt>
              <dd class="ml-2">{{selected.age_at_convention | na_if_empty}}</dd>
              <dt>Romantic and/or sexual orientation:</dt>
              <dd class="ml-2">{{selected.romantic_sexual_orientation | na_if_empty}}</dd>
            </dl>
          </div>
          <div class="w-50">
            <h5>Community Memberships</h5>
            <dl>
              <dt>Experience with being “othered”:</dt>
              <dd class="ml-2">{{selected.othered | na_if_empty }}</dd>
              <dt>Member of an Indigenous community:</dt>
              <dd class="ml-2">{{selected.indigenous | na_if_empty}}</dd>
              <dt>Member of the global Black diaspora:</dt>
              <dd class="ml-2">{{selected.black_diaspora | na_if_empty}}</dd>
              <dt>Represent something other than a purely US-centric perspective:</dt>
              <dd class="ml-2">{{selected.non_us_centric_perspectives| na_if_empty}}</dd>
            </dl>
          </div>
        </div>
        <h5>Other Information</h5>
        <dl>
          <dt>Anyone that should not be assigned to be on a panel with participant:</dt>
          <dd class="ml-2">{{selected.do_not_assign_with | na_if_empty}}</dd>
          <dt>Permission to be included in live streamed program:</dt>
          <dd class="ml-2">{{selected.can_stream | capitalize | na_if_empty}}</dd>
          <dt>Topics participant does not want to be streamed while talking about are:</dt>
          <dd class="ml-2">{{selected.can_stream_exceptions | na_if_empty}}</dd>
          <dt>Permission to be included in recorded program:</dt>
          <dd class="ml-2">{{selected.can_record | capitalize | na_if_empty}}</dd>
          <dt>Topics participant does not want to be recorded talking about:</dt>
          <dd class="ml-2">{{selected.can_record_exceptions | na_if_empty}}</dd>
          <dt>Local to the Event:</dt>
          <dd class="ml-2">{{selected.is_local ? 'Yes' : 'No'}}</dd>
          <dt>Moderating experience:</dt>
          <dd class="ml-2">{{selected.moderation_experience | na_if_empty}}</dd>
          <dt>Languages spoken:</dt>
          <dd class="ml-2">{{selected.languages_fluent_in | na_if_empty}}</dd>
        </dl>
      </div>
    </template>
  </sidebar-vue>
</template>

<script>
import SidebarVue from '../components/sidebar_vue';
import {modelMixin} from '@/mixins';
import modelUtilsMixin from "@/store/model_utils.mixin";

// Seacrh for people to add as participants
export default {
  name: "PersonDetails",
  components: {
    SidebarVue
  },
  mixins: [
    modelMixin,
    modelUtilsMixin
  ],
  computed: {
    sessionComments() {
      if (this.assignment) {
        if (this.assignment.interest_notes) {
          return this.assignment.interest_notes
        }
      }
      return 'N/A'
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
      if (this.selected.willing_to_moderate) return 'Y'
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
      return "Default"
    },
    assignment() {
      let asgnmt = this.selected_model('session_assignment')

      return asgnmt
    }
  }
}
</script>

<style>
</style>
