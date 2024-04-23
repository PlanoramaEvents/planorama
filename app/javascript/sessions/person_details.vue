<template>
  <sidebar-vue width="60%" model="person">
    <template #header v-if="selected">
      <div class="d-flex align-items-baseline">
        <b-link :to="'/people/edit/'.concat(selected.id)">
          <h3 class="mr-auto">
            {{selected.published_name}}
          </h3>
        </b-link>
        <div class="ml-3">Rank: {{rank}}</div>
        <div class="ml-3">Preferencje moderacji sesji: <span class="first-capital">{{sessionModPreference}}</span></div>
      </div>
    </template>
    <template #content v-if="selected">
      <div>
        <div class="mt-2">
          <dl>
            <dt>Komentarze dotyczące sesji:</dt>
            <dd class='ml-2 keep-format'>{{sessionComments}}</dd>
            <dt>Biografia:</dt>
            <dd class='ml-2'>
              <span v-html="selected.bio" v-if="selected.bio"></span>
              <span v-else class="text-muted font-italic">Nieokreślone</span>
            </dd>
          </dl>
        </div>
        <div class="d-flex flex-row mt-3">
          <div class="w-50 mr-2">
            <h5>Dane demograficzne</h5>
            <dl-person :fields="demographicFields"></dl-person>
          </div>
          <div class="w-50">
            <h5>Członkostwo w społecznościach</h5>
            <dl-person :fields="communityFields"></dl-person>
          </div>
        </div>
        <h5>Inne informacje</h5>
        <dl-person :fields="otherFields">
          <template #can_stream-val>{{selected.can_stream | capitalize}}</template>
          <template #can_record-val>{{selected.can_record | capitalize}}</template>
          <template #can_stream_exceptions-label>Tematy, na których uczestnik nie chce być nagrywany podczas dyskusji</template>
          <template #can_record_exceptions-label>Tematy, na których uczestnik nie chce być nagrywany podczas dyskusji</template>
        </dl-person>
      </div>
    </template>
  </sidebar-vue>
</template>

<script>
import SidebarVue from '../components/sidebar_vue';
import {modelMixin} from '@/mixins';
import modelUtilsMixin from "@/store/model_utils.mixin";
import DlPerson from "@/profile/dl_person.vue";
import { peopleHiddenFieldsMixin } from '@/configurations/people_hidden_fields.mixin';

// Seacrh for people to add as participants
export default {
  name: "PersonDetails",
  components: {
    SidebarVue,
    DlPerson
  },
  mixins: [
    modelMixin,
    modelUtilsMixin,
    peopleHiddenFieldsMixin,
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
      return 'Nieocenione'
    },
    demographicFields() {
      return this.filterFieldList(['ethnicity', 'gender', 'age_at_convention', 'romantic_sexual_orientation']);
     
    },
    otherFields() {
      return this.filterFieldList([
        'do_not_assign_with',
        'excluded_demographic_categories',
        'can_stream',
        'can_stream_exceptions',
        'can_record',
        'can_record_exceptions',
        'is_local',
        'moderation_experience',
        'languages_fluent_in'
      ]);
    },
    communityFields() {
      return this.filterFieldList([
        'othered', 
        'indigenous',
        'black_diaspora',
        'global_diaspora',
        'non_anglophone',
        'non_us_centric_perspectives',
        'demographic_categories'
      ])
    },
    defaultModPreference() {
      if (this.selected.willing_to_moderate) return 'Tak'
      return 'Nie'
    },
    sessionModPreference() {
      if (this.assignment) {
        if (this.assignment.interest_role == 'can_moderate') {
          return "Tak"
        } else if (this.assignment.interest_role == 'not_moderate') {
          return "Nie"
        }
      }
      return "Domyślne"
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
