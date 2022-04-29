<template>
  <div class="mb-4 mr-3">
    <div class='row mb-4 pr-1 sticky-top bg-white border-bottom border-dark'>
      <div class="col-8">
        <small>
        <p>
          Once you have selected sessions you are interested in,
          use this page to tell us your level of interest and what you would contribute to the topic.
        </p>
        <p>
          Rank each session from one to three using the following scale:
          <ol>
            <li>I really want to be on this panel (<b>limit of 5</b>)</li>
            <li>I have meaningful contributions to this panel (<b>limit of 5</b>)</li>
            <li>I am willing to be on this panel (<b>unlimited</b>)</li>
          </ol>
        </p>
        <p>
          Use the text box to tell us why you are a good choice for this panel and what you would contribute.
          We will have hundreds of program participants, do not assume that we will just
          "know" what your strengths are - tell us about them!
        </p>
        </small>
      </div>
      <div class="col">
        <h6>
          Current Counts
        </h6>
        Rank 1: <b>{{rank1_total}}</b><br />
        Rank 2: <b>{{rank2_total}}</b><br />
        Rank 3: <b>{{rank3_total}}</b><br />
        Unranked: <b>{{other_total}}</b><br />
      </div>
    </div>
    <!-- :key="item.session.id"  Causes **lots** of vue errors with dups ids-->
     <div class='row mb-4' v-for="item in sortedCollection">
       <div class="col-8">
         <h4>{{item.session.title}}</h4>
         <p v-html="item.session.description"></p>
         <div v-if="item.session.format">
           Format: <span class="badge badge-pill badge-info mr-1">{{item.session.format.name}}</span><br />
         </div>
         <div v-if="item.session.area_list && item.session.area_list.length">
           Area(s): <span class="badge badge-pill badge-primary mr-1" v-for="area in item.session.area_list" :key="area">{{area}}</span>
         </div>
         <div v-if="item.session.tag_list && item.session.tag_list.length">
           Tag(s): <span class="badge badge-pill badge-secondary mr-1" v-for="tag in item.session.tag_list" :key="tag">{{tag}}</span>
         </div>
         <br />
         <div class="mt-3" v-if="item.session.instructions_for_interest">Instructions for potential panelists:</div>
         <div class="panelist-instructions" v-html="item.session.instructions_for_interest"></div>
         <b-textarea
           v-model="item.interest_notes"
           @blur="changeAssignment(item)"
         ></b-textarea>
       </div>
       <div class="col pt-4">
         <session-assignment-monitor
           :assignment="item"
           model="session_assignment"
           @change="changeAssignment"
         ></session-assignment-monitor>
         <b-form-group label="Rank">
           <b-form-select
             v-model="item.interest_ranking"
             :state="errored(item)"
             :options="rankOptions">
           </b-form-select>
         </b-form-group>
         <b-form-group label="Override default moderating preferences for this session only?">
           <b-form-select
             v-model="item.interest_role"
             :options="moderatorOptions">
           </b-form-select>
         </b-form-group>
         <b-button variant="primary" @click="notInterested(item)"><b-icon-trash></b-icon-trash></b-button>
       </div>
     </div>

     <b-modal
       title="Confirm Not Interested"
       ref="unexpress-interest-modal"
       @hidden="stillInterested"
       @ok="okNotInterested"
     >
       <p class="my-4">
         Confirm that you are no longer interested in that session.
       </p>
     </b-modal>
  </div>
</template>

<script>
import modelMixin from '../store/model.mixin';
import tableMixin from '../store/table.mixin';
import personSessionMixin from '../auth/person_session.mixin';
import sessionAssignmentMixin from '../sessions/session_assignment.mixin';
import { sessionAssignmentModel } from '@/store/session_assignment.store'
import SessionAssignmentMonitor from './session_assignment_monitor.vue'

import { SESSION_RANKING_ERROR } from '../constants/strings';

export default {
  name: "SessionRanker",
  components: {
    SessionAssignmentMonitor
  },
  mixins: [
    personSessionMixin,
    modelMixin,
    tableMixin, // covers pagination and sorting
    sessionAssignmentMixin
  ],
  props: {
    person_id: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      moderatorOptions: [
        { text: 'Use default', value: 'no_preference' },
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
  computed: {
    rankOptions() {
      return [
        { value: 1, text: '1', disabled: this.rank1_total > 5},
        { value: 2, text: '2', disabled: this.rank2_total > 5},
        { value: 3, text: '3' },
        { value: null, text: 'Unranked' }
      ]
    },
    rank1_total() {
      let count = this.sortedCollection.filter(obj => obj.interest_ranking === 1).length
      return count
    },
    rank2_total() {
      let count = this.sortedCollection.filter(obj => obj.interest_ranking === 2).length
      return count
    },
    rank3_total() {
      return this.sortedCollection.filter(obj => obj.interest_ranking === 3).length
    },
    other_total() {
      let count = this.sortedCollection.filter(obj => obj.interest_ranking == null).length
      return count
    }
  },
  methods: {
    errored: function(item) {
      if (item.interest_ranking == 1 && this.rank1_total > 5) {
        return false
      }

      if (item.interest_ranking == 2 && this.rank2_total > 5) {
        return false
      }

      return true
    },
    notInterested(arg) {
      this.assignment = arg
      this.$refs['unexpress-interest-modal'].show()
    },
    okNotInterested() {
      if (this.assignment) {
        this.removeInterest(this.assignment, this.person_id).then(
          (res) => {
            this.assignment = null
            this.fetchPaged()
          }
        )
      }
    },
    stillInterested() {
      this.assignment = null
    },
    changeAssignment: function(arg) {
      if (arg.interested) {
        if (arg.interest_ranking == 1 && this.rank1_total > 5) {
          this.$bvToast.toast(
            SESSION_RANKING_ERROR(this.rank1_total, 5),
            {
              variant: 'error',
              title: "Ranking Error"
            }
          )
          return
        }
        if (arg.interest_ranking == 2 && this.rank2_total > 5) {
          this.$bvToast.toast(
            SESSION_RANKING_ERROR(this.rank2_total, 5),
            {
              variant: 'error',
              title: "Ranking Error"
            }
          )
          return
        }
        this.save(arg)
      }
    }
  },
  mounted() {
    // If there is no pager we need to get the initial collection somehow
    // Order should be by created_at date and ranking ...
    this.assignment = null
    this.fetchPaged();
  }
}
</script>

<style>
.panelist-instructions {
  font-style: italic;
}
</style>
