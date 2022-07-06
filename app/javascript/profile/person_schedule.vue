<template>
  <div class="container-fluid">
    <div class="row">
      <div class="col-12">
        <div class="d-flex">
          <h2>Draft Schedule</h2>
          <b-button variant="link" @click="allButton()">{{ anyOpen ? 'Collapse all' : 'Show all'}}</b-button>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-8">
        <schedule-collapse v-for="(session, id) in sessions" :key="id" :id="id" v-model="open[id]">
          <template #title><span class="larger-text"><strong class="larger-text">{{session.title}}</strong>, {{session.room.name || "Room Name Here"}}, {{formatStartTime(session)}}</span></template>
          <dl class="indented-dl">
            <dt>Title</dt>
            <dd>{{session.title}}</dd>
            <dt>Participants (with contact information where allowed)</dt>
            <dd v-for="sa in session.session_assignments" :key="sa.id">{{sa.person.publication_name}}{{ isModerator(sa) ? " (m)" : ""}} {{sa.person.pronouns}} - {{ sa.person.contact_email ? sa.person.contact_email : 'permission not given'}}</dd>
            <dd class="text-muted" v-if="!session.session_assignments.length">None Assigned</dd>
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
    SESSION_ENVIRONMENT
  }),
  computed: {
    amIOpen(id) {
      return this.open[id];
    },
    anyOpen() {
      return Object.values(this.open).some(v => v)
    }
  },
  methods: {
    ...mapActions({
      get: 'jv/get'
    }),
    allButton() {
      const newDir = !this.anyOpen;
      Object.keys(this.open).forEach((id) => {
        this.open[id] = newDir;
        console.log(`changed ${id} to ${this.open[id]}`)
      })
    }
  },
  mounted() {
    if(this.selected) {
      this.get(`/person/${this.selected.id}/draft_sessions`).then(data => {
        console.log(data);
        const {_jv, ...filtered_data} = data;
        this.sessions = filtered_data;
        this.open = Object.keys(this.sessions).reduce((p, c) => ({...p, [c]: false }), {});
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
