<template>
  <div class="container-fluid">
    <div class="row">
      <div class="col-12">
        <div class="d-flex">
          <h2>Live Schedule</h2>
          <b-button variant="link" @click="allButton()">{{ anyOpen ? 'Collapse all' : 'Show all'}}</b-button>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-8" :style="heightHelper">
        <b-overlay :show="loading" spinner-variant="primary" variant="white" opacity="1">
          <schedule-collapse v-for="(session, id) in sessions" :key="id" :id="id" v-model="open[id]">
            <template #title><span class="larger-text"><strong class="larger-text">{{session.title}}</strong>, {{session.room.name || "Room Name Here"}}, {{formatStartTime(session)}}</span></template>
            <dl class="indented-dl">
              <dt>Title</dt>
              <dd>{{session.title}}</dd>
              <dt>Participants (with contact information where allowed)</dt>
              <dd v-for="sa in orderedParticipants(session)" :key="sa.id">{{sa.person.published_name}}{{ isModerator(sa) ? " (m)" : isInvisible(sa) ? " (i)" : ""}} {{sa.person.pronouns}} - {{ sa.person.contact_email ? sa.person.contact_email.email : 'permission not given'}}</dd>
              <dd class="text-muted" v-if="!Object.keys(session.participant_assignments).length">None Assigned</dd>
              <dt>Description</dt>
              <dd v-html="session.description"></dd>
              <dt>Space/Time</dt>
              <dd>{{session.room.name || "Room Name Here"}} {{formatStartTime(session)}}</dd>
              <dt>Duration</dt>
              <dd>{{session.duration}} minutes</dd>
              <dt>Session Environment</dt>
              <dd>{{SESSION_ENVIRONMENT[session.environment]}}</dd>
              <dt>Session Format</dt>
              <dd class="not-italic"><span class="badge badge-pill badge-info">{{session.format.name || session.format_id}}</span></dd>
              <dt>Session Area(s)</dt>
              <dd v-if="session.area_list.length" class="not-italic"><span v-for="area in session.area_list" class="badge badge-pill badge-primary" :key="area">{{area}}</span></dd>
              <dd v-if="!session.area_list.length" class="text-muted">None Selected</dd>
              <dt>Schedule Notes</dt>
              <dd v-html="session.participant_notes"></dd>
            </dl>
          </schedule-collapse>
        </b-overlay>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex';
import ScheduleCollapse from './schedule_collapse.vue';
import { personModel as model } from '@/store/person.store';
import { modelMixinNoProp } from '@/mixins';
import { startTimeMixinNoSelected } from '@/sessions/session_fields.mixin';
import { SESSION_ENVIRONMENT } from '@/constants/strings';
import { sessionRoleMixin } from '@/sessions/session_role.mixin';

export default {
  name: "PersonSchedule",
  components: {
    ScheduleCollapse
  },
  mixins: [
    modelMixinNoProp,
    startTimeMixinNoSelected,
    sessionRoleMixin
  ],
  data: () => ({
    sessions: {},
    open: {},
    model,
    SESSION_ENVIRONMENT,
    loading: false
  }),
  computed: {
    anyOpen() {
      return Object.values(this.open).some(v => v)
    },
    heightHelper() {
      if (this.loading) {
        return {height: '200px', padding: "5rem"}
      }
      return {};
    }
  },
  methods: {
    ...mapActions({
      get: 'jv/get'
    }),
    allButton() {
      const newDir = !this.anyOpen;
      Object.keys(this.open).forEach((id) => {
        if (this.open[id] !== newDir) {
          this.$root.$emit('bv::toggle::collapse', id)
        }
      })
    },
    orderedParticipants(session) {
      const sas = Object.values(session.participant_assignments);
      sas.sort((a, b) => {
        if (a.session_assignment_role_type_id !== b.session_assignment_role_type_id) {
          if (this.isModerator(a)) {
            return -1;
          } else if (this.isModerator(b)) {
            return 1;
          } else if (this.isParticipant(a)) {
            return -1;
          } else if (this.isParticipant(b)) {
            return 1;
          }
          return 1;
        } else {
          const nameA = a.person.published_name_sort_by || a.person.published_name
          const nameB = b.person.published_name_sort_by || a.person.published_name
          if (nameA < nameB) {
            return -1;
          } else if (nameB < nameA) {
            return 1;
          } 
          return 0;
        }
      })
      return sas;
    }
  },
  mounted() {
    if(this.selected) {
      this.loading = true;
      this.get(`/person/${this.selected.id}/draft_sessions`).then(data => {
        console.log(data);
        const {_jv, ...filtered_data} = data;
        this.sessions = filtered_data;
        this.open = Object.keys(this.sessions).reduce((p, c) => ({...p, [c]: false }), {});
        this.loading = false;
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.larger-text {
  font-size: 16px;
}

.indented-dl {
  dd {
    margin-left: 0.5rem;
    &:not(.not-italic) {
      font-style: italic;
    }
  }
}
</style>
