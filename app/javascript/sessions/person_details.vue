<template>
  <sidebar-vue model="person">
    <template #header v-if="selected">
      <!-- TODO: we need to pass in the session assignment -->
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
          <label>Session Comments</label>
          <div class="ml-5" v-if="assignment">
            {{assignment.interest_notes}}
          </div>
        </div>
        <div class="mt-2">
          <label>Bio</label>
          <div class="ml-5" v-if="assignment">
            <span v-html="selected.bio"></span>
          </div>
        </div>
        <div class="d-flex flex-row mt-3">
          <div class="w-50 mr-2">
            <h6>Demographics</h6>
            <ul class="list-unstyled">
              <li class="mb-2"><label>Ethnicity:</label> {{selected.ethnicity}}</li>
              <li class="mb-2"><label>Gender:</label> {{selected.gender}}</li>
              <li class="mb-2"><label>Age at time of Event:</label> {{selected.age_at_convention}}</li>
              <li class="mb-2"><label>Romantic and/or sexual orientation:</label> {{selected.romantic_sexual_orientation}}</li>
            </ul>
          </div>
          <div class="w-50">
            <h6>Community Memberships</h6>
            <ul class="list-unstyled">
              <li class="mb-2"><label>Experience with being “othered”:</label> {{selected.othered}}</li>
              <li class="mb-2"><label>Member of an Indigenous community:</label> {{selected.indigenous}}</li>
              <li class="mb-2"><label>Member of the global Black diaspora:</label> {{selected.black_diaspora}}</li>
              <li class="mb-2"><label>Represent something other than a purely US-centric perspective:</label> {{selected.non_us_centric_perspectives}}</li>
            </ul>
          </div>
        </div>
        <div class="mb-2">
          <label>Anyone that should not be assigned to be on a panel with participant</label>
          <div class="ml-5">
            {{selected.do_not_assign_with ? selected.do_not_assign_with : 'N/A'}}
          </div>
        </div>
        <div class="mb-2">
          <span<label>Permission to be included in live streamed program:</label> {{selected.can_stream}}</span>
        </div>
        <div class="mb-2">
          <label>Topics participant does not want to be streamed while talking about are:</label>
          <div class="ml-5">
            {{selected.can_stream_exceptions ? selected.can_stream_exceptions : 'N/A'}}
          </div>
        </div>
        <div class="mb-2">
          <div><label>Permission to be included in recorded program:</label> {{selected.can_record}}</div>
        </div>
        <div class="mb-2">
          <label>Topics participant does not want to be recorded talking about</label>
          <div class="ml-5">
            {{selected.can_record_exceptions ? selected.can_record_exceptions : 'N/A'}}
          </div>
        </div>
        <div class="mb-2">
          <span><label>Local to the Event:</label> {{selected.is_local ? 'Yes' : 'No'}}</span>
        </div>
        <div class="mb-2">
          <label>Moderating experience</label>
          <div class="ml-5">
            {{selected.moderation_experience ? selected.moderation_experience : 'N/A'}}
          </div>
        </div>
        <div class="mb-2">
          <span><label>Languages spoken:</label> {{selected.languages_fluent_in }}</span>
        </div>
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
