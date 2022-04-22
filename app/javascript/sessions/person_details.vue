<template>
  <sidebar-vue model="person">
    <template #header v-if="selected">
      <!-- TODO: we need to pass in the session assignment -->
      <div class="d-flex">
        <h3 class="mr-auto">{{selected.published_name}}</h3>
        <div class="ml-3">
          Rank: {{rank}}
        </div>
        <div class="ml-3">
          Session moderation preference: {{sessionModPreference}}
        </div>
      </div>
    </template>
    <template #content v-if="selected">
      <div>
        <div class="mt-2">
          <b>Session Comments</b>
          <div class="ml-5" v-if="assignment">
            {{assignment.interest_notes}}
          </div>
        </div>
        <div class="mt-2">
          <b>Bio</b>
          <div class="ml-5" v-if="assignment">
            <span v-html="selected.bio"></span>
          </div>
        </div>
        <div class="d-flex flex-row mt-3">
          <div class="w-50 mr-2">
            <b>Demographics</b>
            <ul class="list-unstyled">
              <li class="mb-2">Ethnicity: {{selected.ethnicity}}</li>
              <li class="mb-2">Gender: {{selected.gender}}</li>
              <li class="mb-2">Age at time of Event: {{selected.age_at_convention}}</li>
              <li class="mb-2">Romantic and/or sexual orientation: {{selected.romantic_sexual_orientation}}</li>
            </ul>
          </div>
          <div class="w-50">
            <b>Community Memberships</b>
            <ul class="list-unstyled">
              <li class="mb-2">Experience with being “othered”: {{selected.othered}}</li>
              <li class="mb-2">Member of an Indigenous community: {{selected.indigenous}}</li>
              <li class="mb-2">Member of the global Black diaspora: {{selected.black_diaspora}}</li>
              <li class="mb-2">Represent something other than a purely US-centric perspective: {{selected.non_us_centric_perspectives}}</li>
            </ul>
          </div>
        </div>
        <div class="mb-2">
          <div>Anyone that should not be assigned to be on a panel with participant</div>
          <div class="ml-5">
            {{selected.do_not_assign_with ? selected.do_not_assign_with : 'N/A'}}
          </div>
        </div>
        <div class="mb-2">
          <div>Permission to be included in live streamed program: {{selected.can_stream}}</div>
        </div>
        <div class="mb-2">
          <div>Topics participant does not want to be streamed while talking about are (this can be updated later):</div>
          <div class="ml-5">
            {{selected.can_stream_exceptions ? selected.can_stream_exceptions : 'N/A'}}
          </div>
        </div>
        <div class="mb-2">
          <div>Permission to be included in recorded program: {{selected.can_record}}</div>
        </div>
        <div class="mb-2">
          <div>Topics participant does not want to be recorded talking about</div>
          <div class="ml-5">
            {{selected.can_record_exceptions ? selected.can_record_exceptions : 'N/A'}}
          </div>
        </div>
        <div class="mb-2">
          <div>Local to the Event: {{selected.is_local ? 'Yes' : 'No'}}</div>
        </div>
        <div class="mb-2">
          <div>Moderating experience</div>
          <div class="ml-5">
            {{selected.moderation_experience ? selected.moderation_experience : 'N/A'}}
          </div>
        </div>
        <div class="mb-2">
          <div>Languages spoken: {{selected.languages_fluent_in }}</div>
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
