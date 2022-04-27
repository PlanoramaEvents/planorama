<template>
  <sidebar-vue width="60%" model="person">
    <template #header v-if="selected">
      <div class="d-flex">
        <h3 class="mr-auto">{{selected.published_name}}</h3>
        <span class="ml-3">
          <label>Rank:</label>
          {{rank}}
        </span>
        <span class="ml-3">
          <label>Session moderation preference:</label>
          {{sessionModPreference}}
        </span>
      </div>
    </template>
    <template #content v-if="selected">
      <div>
        <div class="mt-2">
          <dl>
            <dt>Session Comments:</dt>
            <dd>{{sessionComments}}</dd>
            <dt>Bio:</dt>
            <dd>
              <span v-html="selected.bio"></span>
            </dd>
          </dl>
        </div>
        <div class="d-flex flex-row mt-3">
          <div class="w-50 mr-2">
            <h5>Demographics</h5>
            <dl class="row">
              <dt class="col-sm-12">Ethnicity:</dt>
              <dd class="col-sm-11 offset-sm-1">{{selected.ethnicity}}</dd>
              <dt class="col-sm-12">Gender:</dt>
              <dd class="col-sm-11 offset-sm-1">{{selected.gender}}</dd>
              <dt class="col-sm-12">Age at time of Event:</dt>
              <dd class="col-sm-11 offset-sm-1">{{selected.age_at_convention}}</dd>
              <dt class="col-sm-12">Romantic and/or sexual orientation:</dt>
              <dd class="col-sm-11 offset-sm-1">{{selected.romantic_sexual_orientation}}</dd>
            </dl>
          </div>
          <div class="w-50">
            <h5>Community Memberships</h5>
            <dl class="row">
              <dt class="col-sm-12">Experience with being “othered”:</dt>
              <dd class="col-sm-11 offset-sm-1">{{selected.othered}}</dd>
              <dt class="col-sm-12">Member of an Indigenous community:</dt>
              <dd class="col-sm-11 offset-sm-1">{{selected.indigenous}}</dd>
              <dt class="col-sm-12">Member of the global Black diaspora:</dt>
              <dd class="col-sm-11 offset-sm-1">{{selected.black_diaspora}}</dd>
              <dt class="col-sm-12">Represent something other than a purely US-centric perspective:</dt>
              <dd class="col-sm-11 offset-sm-1">{{selected.non_us_centric_perspectives}}</dd>
            </dl>
          </div>
        </div>

        <dl class="row">
          <dt class="col-sm-12">Anyone that should not be assigned to be on a panel with participant:</dt>
          <dd class="col-sm-11 offset-sm-1">{{selected.do_not_assign_with ? selected.do_not_assign_with : 'N/A'}}</dd>
          <dt class="col-sm-12">Permission to be included in live streamed program:</dt>
          <dd class="col-sm-11 offset-sm-1">{{selected.can_stream}}</dd>
          <dt class="col-sm-12">Topics participant does not want to be streamed while talking about are:</dt>
          <dd class="col-sm-11 offset-sm-1">{{selected.can_stream_exceptions ? selected.can_stream_exceptions : 'N/A'}}</dd>
          <dt class="col-sm-12">Permission to be included in recorded program:</dt>
          <dd class="col-sm-11 offset-sm-1">{{selected.can_record}}</dd>
          <dt class="col-sm-12">Topics participant does not want to be recorded talking about:</dt>
          <dd class="col-sm-11 offset-sm-1">{{selected.can_record_exceptions ? selected.can_record_exceptions : 'N/A'}}</dd>
          <dt class="col-sm-12">Local to the Event:</dt>
          <dd class="col-sm-11 offset-sm-1">{{selected.is_local ? 'Yes' : 'No'}}</dd>
          <dt class="col-sm-12">Moderating experience:</dt>
          <dd class="col-sm-11 offset-sm-1">{{selected.moderation_experience ? selected.moderation_experience : 'N/A'}}</dd>
          <dt class="col-sm-12">Languages spoken:</dt>
          <dd class="col-sm-11 offset-sm-1">{{selected.languages_fluent_in}}</dd>
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
      // {{assignment.interest_role}}
      return "default"
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
