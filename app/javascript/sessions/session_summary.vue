<template>
  <div class="pb-3" v-if="session">
    <div class='d-flex'>
      <div class='w-75'>
        <b-form-group
          class="mx-3"
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
          id="session-description-group"
          label="Session Description"
          label-for="session-description"
        >
          <plano-editor
              id="session-description"
              v-model="session.description"
              type='classic'
              :height="100"
              @change="saveSession()"
          ></plano-editor>
        </b-form-group>
        <b-form-group class="mx-3">
          <b-form-checkbox
            id="session-open-for-interest"
            switch
            v-model="session.open_for_interest"
            @change="saveSession()"
          >
            Open for Interest
            <span v-if="session.open_for_interest">
              on {{ session.interest_opened_at ? new Date(session.interest_opened_at).toLocaleString() : 'n/a'}}
              by {{ session.interest_opened_by ? session.interest_opened_by.toLocaleString() : 'n/a'}}
            </span>
          </b-form-checkbox>
        </b-form-group>
      </div>
      <div class='ml-auto' v-if="session">
        <small class="text-muted d-block">
          Last edited by:
          <em>{{session.updated_by}}</em>
        </small>
        <small class="text-muted d-block">
          Last edited on:
          <em>{{new Date(session.updated_at).toLocaleString()}}</em>
        </small>
        <b-form-group class="mt-5">
          <b-form-checkbox
            id="session-proofed"
            switch
            v-model="session.proofed"
            @change="saveSession()"
          >Copy Edited/Proofed</b-form-checkbox>
        </b-form-group>
        <b-form-group>
          <b-form-checkbox
            id="session-scheduled"
            switch
            disabled
            :checked="scheduled"
          >Scheduled</b-form-checkbox>
        </b-form-group>
        <b-form-group label="Public Schedule Visibility" class="mb-3">
          <span>Not Visible</span>
          <b-form-checkbox
            id="session-public-schedule-visibility"
            switch
            v-model="visibility"
            @change="saveSession()"
            class="d-inline-block"
          >Visible</b-form-checkbox>
        </b-form-group>
        <b-form-group>
          <b-form-checkbox
            id="session-recorded"
            switch
            v-model="session.recorded"
            @change="saveSession()"
          >Will be recorded</b-form-checkbox>
        </b-form-group>
        <b-form-group>
          <b-form-checkbox
            id="session-streamed"
            switch
            v-model="session.streamed"
            @change="saveSession()"
          >Will be livestreamed</b-form-checkbox>
        </b-form-group>
        <b-form-group label="Status" label-cols="auto">
          <b-form-select  id="session-status" v-model="session.status" @change="saveSession()">
            <b-form-select-option
                v-for="status in currentSettings.enums.Session.status"
                :value="status"  v-bind:key="status"
                :title="scheduled && status==='dropped' ? SESSION_MUST_UNSCHEDULE : ''"
                :disabled="scheduled && status==='dropped'">
              {{SESSION_STATUS[status]}}
            </b-form-select-option>
          </b-form-select>
        </b-form-group>
        <b-button v-if="currentUserIsAdmin && airmeetEnabled" variant="warning" :disabled="!session.streamed" @click="resyncAirmeet" class="mt-2">Airmeet re-sync completed</b-button>
      </div>
    </div>
  </div>
</template>

<script>
import { sessionEndpoints, sessionModel } from '@/store/session.store'
import modelUtilsMixin from '@/store/model_utils.mixin';
import { scheduledMixin } from './session_fields.mixin';
import { SESSION_STATUS, SESSION_MUST_UNSCHEDULE } from '@/constants/strings';
import settingsMixin from "@/store/settings.mixin";

import PlanoEditor from '../components/plano_editor';
import { personSessionMixin } from '@/mixins';
import { publishedSessionEndpoints, publishedSessionModel } from '@/store/published_session.store';
import { airmeetMixin } from '@/integrations/airmeet.mixin';

export default {
  name: "SessionSummary",
  components: {
    PlanoEditor
  },
  mixins: [
    modelUtilsMixin,
    scheduledMixin,
    settingsMixin,
    personSessionMixin,
    airmeetMixin
  ],
  data: () => ({
    SESSION_STATUS,
    SESSION_MUST_UNSCHEDULE
  }),
  computed: {
    session() {
      return this.selected_model(sessionModel);
    },
    visibility: {
      get() {
        return this.session.visibility === 'is_public'
      },
      set(val) {
        if (val) {
          this.session.visibility = 'is_public'
        } else {
          this.session.visibility = 'is_private'
        }
      }
    }
  },
  methods: {
    saveSession() {
      return this.save_model(sessionModel, this.session).then()
    },
    resyncAirmeet() {
      this.toastPromise(this.$store.dispatch('jv/get', `${publishedSessionEndpoints[publishedSessionModel]}/${this.session.id}/resync_airmeet`), "Successfully updated airmeet sync data.")
    }
  }
}
</script>

<style>

</style>
