<template>
  <div class="mb-3">
    <div class='row mb-4 sticky-top bg-white border-bottom border-light'>
      <div class="col-8">
        <p>
          Text here explaining that you must rank sessions form 1 to 3, that you can only have 3 1s and 3 2s but unlimited 3s or unranked.
          also 1 means 'i really want to be on this panel' 2 means 'i have meaningful contributions to this panel' and 3 means 'i am willing to be on this panel'
        </p>
      </div>
      <div class="col">
        <h6>
          Current Counts
        </h6>
        Rank 1: <b>{{rank1_total}}</b><br />
        Rank 2: <b>{{rank2_total}}</b><br />
        Rank 3 and Unranked: <b>{{other_total}}</b><br />
      </div>
    </div>
     <div class='row mb-4' v-for="item in sortedCollection">
       <div class="col-8">
         <h4>{{item.session.title}}</h4>
         <p>{{item.session.description}}</p>
         <div v-if="item.session.format">
           Format: <span class="badge badge-pill badge-info mr-1">{{item.session.format.name}}</span><br />
         </div>
         <div v-if="item.session.area_list.length > 0">
           <span class="badge badge-pill badge-primary mr-1" v-for="area in item.session.area_list">{{area}}</span>
         </div>
         <div v-if="item.session.tag_list.length > 0">
           <span class="badge badge-pill badge-secondary mr-1" v-for="tag in item.session.tag_list">{{tag}}</span>
         </div>
         <p>
           <em>{{item.session.instructions_for_interest}}</em>
         </p>
         <b-textarea
           v-model="item.interest_notes"
           debounce="500"
         ></b-textarea>
       </div>
       <div class="col pt-4">
         <session-assignment
           :assignment="item"
           model="session_assignment"
           @change="changeAssignment"
         ></session-assignment>
         <b-form-group label="Rank">
           <b-form-select
             v-model="item.interest_ranking"
             :state="item != errored"
             :options="rankOptions">
           </b-form-select>
         </b-form-group>
         <b-form-group label="Override default moderating preferences?">
           <b-form-select
             v-model="item.interest_role"
             :options="moderatorOptions">
           </b-form-select>
         </b-form-group>
       </div>
     </div>
  </div>
</template>

<script>
import modelMixin from '../store/model.mixin';
import tableMixin from '../store/table.mixin';
import personSessionMixin from '../auth/person_session.mixin';
import { sessionAssignmentModel } from '@/store/session_assignment.store'
import SessionAssignment from './session_assignment.vue'

import { SESSION_RANKING_ERROR } from '../constants/strings';

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
        { value: 1, text: '1' },
        { value: 2, text: '2' },
        { value: 3, text: '3' },
        { value: null, text: 'Unranked' }
      ],
      moderatorOptions: [
        { text: 'Do not override', value: 'no_preference' },
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
      ],
      errored: null
    }
  },
  computed: {
    rank1_total() {
      let count = this.sortedCollection.filter(obj => obj.interest_ranking === 1).length
      return count
    },
    rank2_total() {
      let count = this.sortedCollection.filter(obj => obj.interest_ranking === 2).length
      return count
    },
    other_total() {
      let count = this.sortedCollection.filter(obj => obj.interest_ranking === 3 || obj.interest_ranking == null).length
      return count
    }
  },
  methods: {
    changeAssignment: function(arg) {
      if (this.rank1_total > 3) {
        this.$bvToast.toast(
          SESSION_RANKING_ERROR(this.rank1_total, 3),
          {
            variant: 'error',
            title: "Ranking Error"
          }
        )
        this.errored = arg
        return
      }
      if (this.rank2_total > 3) {
        this.$bvToast.toast(
          SESSION_RANKING_ERROR(this.rank2_total, 3),
          {
            variant: 'error',
            title: "Ranking Error"
          }
        )
        this.errored = arg
        return
      }
      this.errored = false
      this.save(arg)
    }
  },
  mounted() {
    // If there is no pager we need to get the initial collection somehow
    // Order should be by created_at date and ranking ...
    this.fetchPaged();
  }
}
</script>

<style>
</style>
