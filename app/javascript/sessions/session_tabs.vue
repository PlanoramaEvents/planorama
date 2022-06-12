<template>
  <div>
    <b-button variant="link" @click="back">Back</b-button>
    <session-summary ></session-summary>
    <b-tabs content-class="mt-3" @activate-tab="handleTabActivation" v-if="session">
      <b-tab title="General" :active="tab === 'edit'">
        <session-edit></session-edit>
      </b-tab>
      <b-tab title="Participant Assignment" :active="tab === 'assignment'" lazy>
        <assign-participants
          defaultSortBy='session_assignments.interest_ranking, people.published_name'
          :defaultSortDesc="false"
          :perPage="200"
          :defaultFilter="assignmentFilter"
          :model="sessionAssignmentModel"
          nullsFirst="false"
        ></assign-participants>
      </b-tab>
      <b-tab title="Schedule" :active="tab === 'schedule'" lazy>
        <session-schedule></session-schedule>
      </b-tab>
      <b-tab title="Conflicts" :active="tab === 'conflicts'">
        <session-conflicts
          :model="sessionConflictModel"
          :sessionId="id"
          :timezone="timezone"
          ref="conflict-reporting"
        ></session-conflicts>
      </b-tab>
      <b-tab title="Notes" :active="tab === 'notes'">
        <session-notes></session-notes>
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
import SessionNotes from './session_notes'
import SessionSchedule from './session_schedule';
import SessionConflicts from '../conflicts/session_conflicts.vue'
import { sessionConflictModel } from '@/store/session_conflict.store'
import settingsMixin from "@/store/settings.mixin";

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
    SessionEdit,
    SessionNotes,
    SessionSchedule,
    SessionConflicts
  },
  mixins: [
    modelUtilsMixin,
    settingsMixin
  ],
  data: () => ({
    sessionAssignmentModel,
    sessionConflictModel
  }),
  computed: {
    session() {
      return this.selected_model(sessionModel);
    },
    assignmentFilter() {
      let filter = {
        "op": "all",
        "queries":[
          ["session_id", "=", this.id],
          ["person.con_state", "!=", "declined"],
          ["person.con_state", "!=", "rejected"],
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
    },
    timezone() {
      let tz = this.configByName('convention_timezone')
      return tz
    },
  },
  methods: {
    back() {
      this.$router.push('/sessions')
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
          path = `conflicts/${this.id}`;
          break;
        case 4:
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
        this.select_model(sessionModel, obj);
      }
    )
  }
}
</script>

<style>

</style>
