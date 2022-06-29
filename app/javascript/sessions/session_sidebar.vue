<template>
  <div class="detail">
    <sidebar-vue v-if="selected" model="session">
      <template #header>
        <h3>{{selected.title}}</h3>
        <small class="text-muted d-block">Last updated:</small>
        <!-- <small class="text-muted d-block"> by <em><strong>{{selected.updated_by && selected.updated_by.name}}</strong></em></small> -->
        <small class="text-muted d-block"> on <em><strong>{{new Date(selected.updated_at).toLocaleString()}}</strong></em></small>
      </template>
      <template #content v-if="selected">
        <b-row>
          <b-col>
            <dl>
              <dt>
                Description:
              </dt>
              <dd>
                <div v-html="selected.description"></div>
              </dd>
            </dl>
          </b-col>
        </b-row>
        <b-row>
          <div class="col-12 col-md-6 col-lg-4">
            <b-form-group>
              <b-form-checkbox v-model="selected.open_for_interest" disabled switch>
                Open for Interest
              </b-form-checkbox>
            </b-form-group>
          </div>
          <div class="col-12 col-md-6 col-lg-4">
            <b-form-group>
              <b-form-checkbox switch v-model="selected.proofed" disabled>
                Copy Edited/Proofed
              </b-form-checkbox>
            </b-form-group>
          </div>
          <div class="col-12 col-md-6 col-lg-4">
            <b-form-group>
              <b-form-checkbox switch disabled :checked="scheduled">
                Scheduled
              </b-form-checkbox>
            </b-form-group>
          </div>
        </b-row>
        <div class="float-right d-flex justify-content-end">
          <b-button title="Edit Session" variant="primary" :to="editLink"><b-icon-pencil variant="white"></b-icon-pencil></b-button>
        </div>
        <b-tabs content-class="mt-3" nav-class="border-0" nav-wrapper-class="border-bottom">
          <!-- TODO: more details etc -->
          <b-tab title="General" active lazy>
            <dl>
              <dt>Areas</dt>
              <dd v-if="selected.area_list.length" class="ml-2 font-italic">{{formattedAreaList}}</dd>
              <dd v-if="!selected.area_list.length" class="ml-2 font-italic text-muted">None Selected</dd>
              <dt>Format</dt>
              <dd class="ml-2 font-italic">{{selected.format.name}}</dd>
              <!-- <dt>Attendee Signup Required</dt>
              <dd class="ml-2 font-italic">{{selected.require_signup ? 'Yes' : 'No'}}</dd>
              <dt class="ml-2">If "Yes", max openings</dt>
              <dd class="ml-3 font-italic">{{selected.maximum_people}}</dd>
              <dd class="ml-3 font-italic text-muted" v-if="!selected.maximum_people">None Set</dd> -->
              <dt>Interest Instructions</dt>
              <dd class="ml-2 font-italic" v-html="selected.instructions_for_interest"></dd>
              <dd class="ml-2 font-italic text-muted" v-if="!selected.instructions_for_interest">No Entry</dd>
              <dt>Scheduled Participant Notes</dt>
              <dd class="ml-2 font-italic" v-html="selected.participant_notes"></dd>
              <dd class="ml-2 font-italic text-muted" v-if="!selected.participant_notes">No Entry</dd>
              <dt>Tech/Hotel Notes</dt>
              <dd class="ml-2 font-italic keep-format">{{selected.tech_notes}}</dd>
              <dd class="ml-2 font-italic text-muted" v-if="!selected.tech_notes">No Entry</dd>
            </dl>
          </b-tab>
          <b-tab title="Participant Assignment">
            <view-participants :session="selected"></view-participants>
          </b-tab>
          <b-tab title="Schedule">
            <dl>
              <dt>Space</dt>
              <dd v-if="selected.room" class="ml-2 font-italic">{{selected.room.name}}</dd>
              <dd v-if="!selected.room" class="ml-2 font-italic text-muted">No space selected</dd>
              <dt>Time</dt>
              <dd v-if="selected.start_time" class="ml-2 font-italic">{{formattedStartTime}}</dd>
              <dd v-if="!selected.start_time" class="ml-2 font-italic text-muted">No time selected</dd>
              <dt>Duration</dt>
              <dd class="ml-2 font-italic">{{selected.duration}} minutes</dd>
            </dl>
          </b-tab>
          <b-tab title="Conflicts" lazy>
            <session-conflicts
              :model="sessionConflictModel"
              :sessionId="selected.id"
              :displaySessionInfo="false"
              ref="conflict-reporting"
            ></session-conflicts>
          </b-tab>
          <b-tab title="Notes">
            <session-notes></session-notes>
          </b-tab>
          <!-- <survey-settings-tab></survey-settings-tab> -->
        </b-tabs>
      </template>
    </sidebar-vue>
  </div>
</template>

<script>
import SidebarVue from '@/components/sidebar_vue';
import SessionNotes from './session_notes.vue';
import ViewParticipants from './view_participants';
import {personSessionMixin, modelMixin} from '@/mixins';
import Detail from './detail.vue';
import { areaMixin, scheduledMixin, startTimeMixin } from './session_fields.mixin';
import { sessionConflictModel } from '@/store/session_conflict.store';
import SessionConflicts from '@/conflicts/session_conflicts.vue';
// import SessionAdminTab from './session_admin_tab';

export default {
  name: 'SessionSidebar',
  components: {
    SidebarVue,
    Detail,
    SessionNotes,
    ViewParticipants,
    SessionConflicts
  },
  mixins: [
    modelMixin,
    personSessionMixin,
    areaMixin,
    scheduledMixin,
    startTimeMixin
  ],
  data: () => ({
    sessionConflictModel
  }),
  computed: {
    editLink() {
      return `/sessions/edit/${this.selected.id}`;
    },
  }
}
</script>
