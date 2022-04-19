<template>
  <div class="session scrollable">
    <b-button variant="link" @click="back">Back</b-button>
    <!-- {{ session }} -->
    <div class='d-flex'>
      <div class='w-75'>
        <b-form-group
          class="mx-3"
          v-if="session"
          id="session-title-group"
          label="Session Title"
          label-for="session-title"
        >
          <b-form-input
            id="session-title"
            type="text"
            v-model="session.title"
            @blur="saveSession()"
          ></b-form-input>
        </b-form-group>
        <b-form-group
          class="mx-3"
          v-if="session"
          id="session-description-group"
          label="Session Description"
          label-for="session-description"
        >
          <plano-editor
              id="session-description"
              v-model="session.description"
              type='classic'
              :height=100
              @blur="saveSession()"
          ></plano-editor>
        </b-form-group>
        <b-form-group class="mx-3">
          <b-form-checkbox
            switch
            v-if="session"
            v-model="session.open_for_interest"
            @change="saveSession()"
          >
            Open for Interest
          </b-form-checkbox>
          <!-- TODO: we need the date when the session was opened for interest .... -->
        </b-form-group>
      </div>
      <div class='ml-auto' v-if="session">
        <!-- TODO: update details here -->
        <small class="text-muted d-block">Last updated:</small>
        <!-- <small class="text-muted d-block"> by <em><strong>{{selected.updated_by && selected.updated_by.name}}</strong></em></small> -->
        <small class="text-muted d-block">Last edited on:<em><strong>{{new Date(session.updated_at).toLocaleDateString()}}</strong></em></small>
      </div>
    </div>

    <b-tabs>
      <!-- Each of these tabs may need to reload the session on mount??? -->
      <b-tab title="Participant Assignment" lazy>
        <assign-participants
          v-model="session"
          defaultSortBy='session_assignments.interest_ranking'
          :perPage="200"
          :model="sessionAssignmentModel"
          :defaultFilter="assignmentFilter"
        ></assign-participants>
      </b-tab>
      <b-tab title="Schedule" lazy>
        TODO - schedule this one session !!!
      </b-tab>
      <b-tab title="Notes" lazy>
        TODO - Notes for this one session
      </b-tab>
    </b-tabs>
  </div>
</template>

<script>
import { sessionModel as model } from '../store/session.store';
import { sessionAssignmentModel } from '@/store/session_assignment.store'

import sessionMixin from './session.mixin';
import PlanoEditor from '../components/plano_editor';

import AssignParticipants from './assign_participants'

export default {
  name: "SessionManage",
  props: ['id'],
  data: () => ({
    model,
    sessionAssignmentModel
  }),
  components: {
    PlanoEditor,
    AssignParticipants
  },
  mixins: [
    sessionMixin
  ],
  computed: {
    assignmentFilter() {
      return `{"op":"all","queries":[["session_id", "=", "${this.id}"]]}`
    }
  },
  methods: {
    init() {
      let s = this.selectSession(this.id)
      console.debug('MANGE SESSION INIT', this.id, s)
      this.fetchSelectedSession().then(() => {
      });
    },
    // saveSession() {
    //   console.debug("SAVE SESSIOn")
    // },
    back() {
      // this.unselectSurvey();
      // this.unselectPage();
      // this.unselectQuestion();

      // TODO: should this back to surveys ...
      this.$router.push('/sessions');
    }
  },
  mounted() {
    this.init()
  }
}
</script>

<style>
</style>
