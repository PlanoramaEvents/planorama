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
            <dd>{{selected.interest_notes ? selected.interest_notes : 'N/A'}}</dd>
            <dt>Bio:</dt>
            <dd>
              <span v-html="selected.bio"></span>
            </dd>
          </dl>
        </div>
        <div class="d-flex flex-row mt-3">
          <div class="w-50 mr-2">
            <h6>Demographics</h6>
            <dl>
              <dt>Ethnicity:</dt>
              <dd>{{selected.ethnicity}}</dd>
              <dt>Gender:</dt>
              <dd>{{selected.gender}}</dd>
              <dt>Age at time of Event:</dt>
              <dd>{{selected.age_at_convention}}</dd>
              <dt>Romantic and/or sexual orientation:</dt>
              <dd>{{selected.romantic_sexual_orientation}}</dd>
            </dl>
          </div>
          <div class="w-50">
            <h6>Community Memberships</h6>
            <dl>
              <dt>Experience with being “othered”:</dt>
              <dd>{{selected.othered}}</dd>
              <dt>Member of an Indigenous community:</dt>
              <dd>{{selected.indigenous}}</dd>
              <dt>Member of the global Black diaspora:</dt>
              <dd>{{selected.black_diaspora}}</dd>
              <dt>Represent something other than a purely US-centric perspective:</dt>
              <dd>{{selected.non_us_centric_perspectives}}</dd>
            </dl>
          </div>
        </div>

        <dl>
          <dt>Anyone that should not be assigned to be on a panel with participant:</dt>
          <dd>{{selected.do_not_assign_with ? selected.do_not_assign_with : 'N/A'}}</dd>
          <dt>Permission to be included in live streamed program:</dt>
          <dd>{{selected.can_stream}}</dd>
          <dt>Topics participant does not want to be streamed while talking about are:</dt>
          <dd>{{selected.can_stream_exceptions ? selected.can_stream_exceptions : 'N/A'}}</dd>
          <dt>Permission to be included in recorded program:</dt>
          <dd>{{selected.can_record}}</dd>
          <dt>Topics participant does not want to be recorded talking about:</dt>
          <dd>{{selected.can_record_exceptions ? selected.can_record_exceptions : 'N/A'}}</dd>
          <dt>Local to the Event:</dt>
          <dd>{{selected.is_local ? 'Yes' : 'No'}}</dd>
          <dt>Permission to be included in live streamed program:</dt>
          <dd>{{selected.moderation_experience ? selected.moderation_experience : 'N/A'}}</dd>
          <dt>Languages spoken:</dt>
          <dd>{{selected.languages_fluent_in}}</dd>
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
