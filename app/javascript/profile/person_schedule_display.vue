<template>
  <div class="container-fluid">
    <div class="row">
      <div class="col-12">
        <div class="d-flex">
          <h2>{{title}}</h2>
          <b-button class="ml-2" variant="link" @click="allButton()">{{ anyOpen ? 'Zwiń wszystkie' : 'Pokaż wszystkie'}}</b-button>
        </div>
      </div>
    </div>
    <div class="row">
      <div :class="{'col-8': !noSidebar, 'col-12': noSidebar}" :style="heightHelper">
        <b-overlay :show="loading" spinner-variant="primary" variant="white" opacity="1">
          <schedule-collapse v-for="(session) in orderedSessions" :key="session.id" :id="session.id" v-model="open[session.id]">
            <template #title><span class="larger-text"><strong class="larger-text">{{session.title}}</strong>, {{formatStartTime(session)}}, {{session.room}}</span></template>
            <dl class="indented-dl">
              <dt>Tytuł</dt>
              <dd>{{session.title}}</dd>
              <dt>Uczestnicy (z informacjami kontaktowymi, jeśli są dostępne)</dt>
              <dd v-for="p in session.moderators" :key="p.published_name">{{p.published_name}} (m) {{p.pronouns}} - {{ p.email ? p.email : 'brak zgody'}}</dd>
              <dd v-for="p in session.participants" :key="p.published_name">{{p.published_name}} {{p.pronouns}} - {{ p.email ? p.email : 'brak zgody'}}</dd>
              <dd v-for="p in session.invisibles" :key="p.published_name">{{p.published_name}} (i) {{p.pronouns}} - {{ p.email ? p.email : 'brak zgody'}}</dd>
              <!--<dd class="text-muted" v-if="!Object.keys(session.participant_assignments).length">None Assigned</dd>-->
              <dt>Opis</dt>
              <dd v-html="session.description"></dd>
              <dt>Miejsce/Czas</dt>
              <dd>{{session.room}} {{formatStartTime(session)}}</dd>
              <dt>Czas trwania</dt>
              <dd>{{session.duration}} minut</dd>
              <dt>Środowisko sesji</dt>
              <dd>{{SESSION_ENVIRONMENT[session.environment]}}</dd>
              <dt>Format sesji</dt>
              <dd class="not-italic"><span class="badge badge-pill badge-info">{{session.format}}</span></dd>
              <dt>Obszar(y) sesji</dt>
              <dd v-if="session.areas.length" class="not-italic"><span v-for="area in session.areas" class="badge badge-pill badge-primary" :key="area">{{area}}</span></dd>
              <dd v-if="!session.areas.length" class="text-muted">Brak wybranych obszarów</dd>
              <dt>Notatki z harmonogramu</dt>
              <dd v-html="session.participant_notes"></dd>
            </dl>
          </schedule-collapse>
          <div v-if="noSessions" class="p-5 text-muted font-italic">Obecnie nie ma żadnych sesji dla tego uczestnika.</div>
        </b-overlay>
      </div>
      <div class="col-4" v-if="!noSidebar">
        <slot name="message"></slot>
        <person-schedule-approval :approvalType="approvalType"></person-schedule-approval>
      </div>
    </div>
  </div>
</template>

<script>
import ScheduleCollapse from './schedule_collapse.vue';
import PersonScheduleApproval from './person_schedule_approval.vue';
import { startTimeMixinNoSelected } from '@/sessions/session_fields.mixin';
import { SESSION_ENVIRONMENT } from '@/constants/strings';

export default {
  name: "PersonScheduleDisplay",
  components: {
    ScheduleCollapse,
    PersonScheduleApproval
  },
  mixins: [
    startTimeMixinNoSelected,
  ],
  props: {
    sessions: {
      type: Object,
      default: {}
    },
    title: {
      type: String,
      default: "Harmonogram"
    },
    approvalType: {
      type: String,
      default: null
    },
    noSidebar: {
      type: Boolean,
      default: false
    }
  },
  data: () => ({
    open: {},
    SESSION_ENVIRONMENT,
    loading: true
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
    },
    orderedSessions() {
      const sessions = Object.values(this.sessions);
      sessions.sort((a, b) => new Date(a.start_time) - new Date(b.start_time))
      return sessions;
    },
    noSessions() {
      return this.sessions && !Object.keys(this.sessions).length;
    }
  },
  methods: {
    allButton() {
      const newDir = !this.anyOpen;
      Object.keys(this.open).forEach((id) => {
        if (this.open[id] !== newDir) {
          this.$root.$emit('bv::toggle::collapse', id)
        }
      })
    },
  },
  watch: {
    sessions(newVal, oldVal) {
      // if newVal exists and has data and isn't the same as oldVal with loose comparison
      if (newVal && newVal != oldVal) {
        if (Object.keys(newVal).length) {
          this.open = Object.keys(newVal).reduce((p, c) => ({...p, [c]: false }), {});
        }
        this.loading = false;
      }
    }
  },
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
