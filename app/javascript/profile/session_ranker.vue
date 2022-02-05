<template>
  <div class="mb-3">
     <p>
       Explaination stuff in here....
     </p>
     <b-table
       hover responsive small striped borderless
       :fields="columns"
       :items="sortedCollection"
       :no-local-sorting="true"
     >
      <template #table-colgroup="scope">
        <col
          v-for="field in scope.fields"
          :key="field.key"
          :style="{ width: field.key === 'id' ? '30%' : '70%' }"
        >
      </template>
      <template #cell(title)="{ item }">
        <h4>{{item.session.title}}</h4>
        <p>{{item.session.description}}</p>
        <p>
          <em>{{item.session.instructions_for_interest}}</em>
        </p>
        <!-- Input field for notes from participants -->
        <b-textarea
          v-model="item.interest_notes"
          debounce="500"
        ></b-textarea>
      </template>
      <template #cell(id)="{ item }">
        <!-- Rank and moderate components -->
        <session-assignment
          :assignment="item"
          model="session_assignment"
          @change="changeAssignment"
        ></session-assignment>
        <b-form-group>
          <b-form-select
            v-model="item.interest_ranking"
            :options="rankOptions">
          </b-form-select>
        </b-form-group>
        <!-- name it based on the id of the item -->
        <b-form-radio-group
          v-model="item.interest_role"
          :options="moderatorOptions"
          :name="'moderate-'+item.id"
        ></b-form-radio-group>
      </template>
    </b-table>
  </div>
</template>

<script>
import modelMixin from '../store/model.mixin';
import tableMixin from '../store/table.mixin';
import personSessionMixin from '../auth/person_session.mixin';
import { sessionAssignmentModel } from '@/store/session_assignment.store'
import SessionAssignment from './session_assignment.vue'

export default {
  name: "SessionRanker",
  components: {
    SessionAssignment
  },
  mixins: [
    personSessionMixin,
    modelMixin,
    tableMixin // covers pagination and sorting
  ],
  data() {
    return {
      rankOptions: [
        { value: null, text: 'Unranked' },
        { value: 1, text: '1' },
        { value: 2, text: '2' },
        { value: 3, text: '3' }
      ],
      moderatorOptions: [
        { text: 'No Preference', value: 'no_preference' },
        { text: 'I would like to moderate this', value: 'can_moderate' },
        { text: 'I would NOT like to moderate this', value: 'not_moderate' }
      ],
      columns : [
        {
          key: 'title',
          label: ' ',
          sortable: false
        },
        {
          key: 'id',
          label: ' ',
          sortable: false
        }
      ]
    }
  },
  methods: {
    changeAssignment: function(arg) {
      console.debug("The assignment has changed", arg)
      // TODO: validate and save
      // arg.
    }
  },
  mounted() {
    // If there is no pager we need to get the initial collection somehow
    this.fetchPaged();
  }
}
</script>

<style>
</style>
