<template>
  <div>
    <b-button variant="link" @click="back">Back</b-button>
    <session-summary
      :session="session"
      @input="onSessionUpdate"
      v-if="session"
    ></session-summary>
    <b-tabs content-class="mt-3" @activate-tab="handleTabActivation" v-if="session">
      <b-tab title="General" :active="tab === 'session-edit'">
        <session-edit v-model="session"></session-edit>
      </b-tab>
      <b-tab title="Participant Assignment" :active="tab === 'session-assignment'" lazy>
        <assign-participants
          v-model="session"
          defaultSortBy='session_assignments.interest_ranking, people.published_name'
          :defaultSortDesc="false"
          defaultO
          :perPage="200"
          :model="sessionAssignmentModel"
          :defaultFilter="assignmentFilter"
          nullsFirst="false"
          @input="onSessionUpdate"
        ></assign-participants>
      </b-tab>
      <b-tab title="Schedule" :active="tab === 'session-schedule'" disabled lazy>
        Schedule
      </b-tab>
      <b-tab title="Notes" :active="tab === 'session-notes'" disabled lazy>
        Notes
      </b-tab>
    </b-tabs>
  </div>
</template>

<script>
import VueRouter from 'vue-router';
const { isNavigationFailure, NavigationFailureType } = VueRouter;
import { sessionModel } from '@/store/session.store'
import { sessionAssignmentModel } from '@/store/session_assignment.store'
import modelUtilsMixin from '@/store/model_utils.mixin';
import AssignParticipants from './assign_participants'
import SessionSummary from './session_summary'
import SessionEdit from './session_edit'

import {
  sessionMixin
}from '@mixins'

export default {
  name: "SessionTabs",
  props: [
    'id',
    'tab'
  ],
  components: {
    SessionSummary,
    AssignParticipants,
    SessionEdit
  },
  mixins: [
    modelUtilsMixin
  ],
  data: () => ({
    sessionAssignmentModel,
    session: null
  }),
  computed: {
    assignmentFilter() {
      let filter = {
        "op": "all",
        "queries":[
          ["session_id", "=", this.id],
          {
            "op": "any",
            "queries": [
              ["interested","=","true"],
              ["state","!=","proposed"],
              ["session_assignment_role_type_id","is not null"]
            ]
          },
        ]
      }

      return JSON.stringify(filter)
    }
  },
  methods: {
    onSessionUpdate(arg) {
      this.session = arg
    },
    back() {
      this.$router.push('/sessions');
    },
    handleTabActivation(newTab, oldTab, bvEvent) {
      // console.debug("****** tab action", newTab, oldTab, bvEvent)
      let path = '';
      switch(newTab) {
        case 0:
          path = `edit/${this.id}`;
          break;
        case 1:
          path = `assignment/${this.id}`;
          break;
        case 2:
          path = `schedule/${this.id}`;
          break;
        case 3:
          path = `notes/${this.id}`;
          break;
      }
      // console.debug("****** Path:", path)
      // change the router path to match the current tab
      // so that reloads work right
      this.$router.push(`/sessions/${path}`).catch(error => {
        if(!isNavigationFailure(error, NavigationFailureType.duplicated)) {
          // ignore the duplicates, otherwise -
          throw error;
        }
      })
    }
  },
  mounted() {
    // get the session (latest)
    this.fetch_model_by_id(sessionModel, this.id).then(
      (obj) => {
        this.session = obj
      }
    )
  }
}
</script>

<style>

</style>
