<template>
  <div class="session-conflicts">
    <b-overlay :show="loading" rounded="sm">
      <div class="session-conflicts-list">
        <div v-if="displaySessionInfo && sessionId">
          <strong>{{sessionTitle}}</strong><br />
          {{sessionTime}}
        </div>
        <div class="ml-2" v-if="(conflicts.length > 0) || (conflicts_with.length > 0)">
          <div
            class="session-conflict mb-1"
            v-for="conflict in conflicts" :key="conflict.id"
          >
            <div  v-html="conflict_type_string(conflict)"></div>
            <ignore-button @click="ignore(conflict)"></ignore-button>
          </div>
          <div
            class="session-conflict mb-1"
            v-for="conflict in conflicts_with" :key="conflict.id"
          >
            <div  v-html="conflict_type_string(conflict, true)"></div>
            <ignore-button @click="ignore(conflict)"></ignore-button>
          </div>
        </div>
        <div class="ml-2 text-muted font-italic" v-else-if="sessionId && conflicts.length === 0 && conflicts_with.length === 0">
          Nie ma konfliktów dla tej sesji
        </div>
      </div>
    </b-overlay>
  </div>
</template>

<script>
import sessionConflictMixin from '../store/session_conflict.mixin';
import modelMixin from '../store/model.mixin';
import modelUtilsMixin from "@/store/model_utils.mixin"
import { sessionModel } from '@/store/session.store'
import dateTimeMixin from '../components/date_time.mixin'
import IgnoreButton from './ignore_button.vue';

export default {
  name: "SessionConflicts",
  mixins: [
    modelMixin,
    modelUtilsMixin,
    dateTimeMixin,
    sessionConflictMixin
  ],
  props: {
    sessionId: null,
    displaySessionInfo: {
      type: Boolean,
      default: true
    }
  },
  data: () =>  ({
    conflicts: [],
    conflicts_with: [],
    loading: false
  }),
  components: {
    IgnoreButton
  },
  computed: {
    selectedSession() {
      return this.get_model(sessionModel, this.sessionId)
    },
    sessionTitle() {
      // conflicts[0].session.title
      if (this.selectedSession) {
        return this.selectedSession.title
      } else {
        return ''
      }
      // return this.selected_model(sessionModel);
    },
    sessionTime() {
      return this.formatLocaleDate(this.selectedSession.start_time )
    }
  },
  watch: {
    sessionId(newVal, oldVal) {
      if (newVal) {
        this.getConflicts(newVal)
      } else {
        this.conflicts = []
        this.conflicts_with = []
      }
    }
  },
  methods: {
    ignore(conflict) {
      this.ignore_conflict({conflict_id: conflict.id, conflict_type: conflict.conflict_type}).then(
        () => {
          this.getConflicts(this.sessionId)
        }
      )
    },
    refreshConflicts() {
      this.getConflicts(this.sessionId)
    },
    getConflicts(sessionId) {
      this.loading = true
      this.conflicts = []
      this.conflicts_with = []
      this.clear()
      let p1 = this.get_conflicts({session_id: sessionId});
      p1.then(
        (conflicts) => {
          this.conflicts = Object.values(conflicts).filter(
            obj => (typeof obj.json === 'undefined')
          )
        }
      )
      let p2 = this.get_conflicts_with({session_id: sessionId});
      p2.then(
        (conflicts) => {
          this.conflicts_with = Object.values(conflicts).filter(
            obj => (typeof obj.json === 'undefined')
          )
        }
      )
      Promise.all([p1, p2]).then((values) => {
        this.loading = false
      });
    },
    // TODO template these
    conflict_type_string(conflict, conflict_with=false) {
      switch(conflict.conflict_type){
        case 'person_exclusion_conflict':
          return `<a href="/#/people/edit/${conflict.person_id}">${conflict.person_published_name}</a> zaplanowano w sposób wykluczający`
        case 'availability_conflict':
          return `<a href="/#/people/edit/${conflict.person_id}">${conflict.person_published_name}</a> jest poza zakresem dostępności`
        case 'room_conflict':
          let start_time = this.formatLocaleDate(conflict.session_start_time) //DateTime.fromISO(conflict.session_start_time).setZone(this.timezone)
          if (conflict_with) {
            return `${conflict.room_name}<br />
             ${start_time} <br />
             "<a href="/#/sessions/edit/${conflict.conflict_session_id}">${conflict.conflict_session_title}</a>"
             koliduje z  <br />
             "<a href="/#/sessions/edit/${conflict.session_id}">${conflict.session_title}</a>"`
          } else {
            return `${conflict.room_name}<br />
            ${start_time} <br />
            "<a href="/#/sessions/edit/${conflict.session_id}">${conflict.session_title}</a>"
            koliduje z  <br />
            "<a href="/#/sessions/edit/${conflict.conflict_session_id}">${conflict.conflict_session_title}</a>"`
          }
        case 'person_schedule_conflict':
          if (conflict_with) {
            return `<a href="/#/people/edit/${conflict.person_id}">${conflict.person_published_name}</a> ma zduplikowane rezerwacje z
                   "<a href="/#/sessions/edit/${conflict.conflict_session_id}">${conflict.conflict_session_title}</a>"
                   i "<a href="/#/sessions/edit/${conflict.session_id}">${conflict.session_title}</a>"`
          } else {
            return `<a href="/#/people/edit/${conflict.person_id}">${conflict.person_published_name}</a> ma zduplikowane rezerwacje z
                   "<a href="/#/sessions/edit/${conflict.session_id}">${conflict.session_title}</a>"
                   i "<a href="/#/sessions/edit/${conflict.conflict_session_id}">${conflict.conflict_session_title}</a>"`
          }
        case 'person_back_to_back':
          if (conflict_with) {
            return `<a href="/#/people/edit/${conflict.person_id}">${conflict.person_published_name}</a> ma sesje bez przerwy z
                   "<a href="/#/sessions/edit/${conflict.conflict_session_id}">${conflict.conflict_session_title}</a>"
                   i "<a href="/#/sessions/edit/${conflict.session_id}">${conflict.session_title}</a>"`
          } else {
            return `<a href="/#/people/edit/${conflict.person_id}">${conflict.person_published_name}</a> ma sesje bez przerwy z
                   "<a href="/#/sessions/edit/${conflict.session_id}">${conflict.session_title}</a>"
                   i "<a href="/#/sessions/edit/${conflict.conflict_session_id}">${conflict.conflict_session_title}</a>"`
          }
        default:
          return `Jakiś konflikt ${conflict}`
      }
    }
  },
  mounted() {
    if (this.sessionId) {
      this.getConflicts(this.sessionId)
    }
  }
}
</script>

<style lang="scss">
.session-conflicts-list {
  overflow-y: auto;
  max-height: 300px;
}

.session-conflict:first-child {
  margin-top: 1em;
}

.session-conflict:not(:first-child) {
  border-top: 1px solid rgba(0,100,150,.15);
}

</style>
