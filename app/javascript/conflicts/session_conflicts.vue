<template>
  <div class="session-conflicts">
    <div class="session-conflicts-list" v-if="(conflicts.length > 0) || (conflicts_with.length > 0)">
      <div v-if="displaySessionInfo && conflicts.length > 0">
        <strong>{{sessionTitle}}</strong><br />
        {{ formatLocaleDate(conflicts[0].session_start_time )}}
      </div>
      <div v-if="displaySessionInfo && conflicts_with.length > 0">
        <strong>{{sessionTitle}}</strong><br />
        {{ formatLocaleDate(conflicts_with[0].session_start_time )}}
      </div>
      <div class="ml-2" v-if="conflicts.length > 0">
        <div
          class="session-conflict mb-1"
          v-for="conflict in conflicts" :key="conflict.id"
        >
          <div  v-html="conflict_type_string(conflict)"></div>
        </div>
      </div>
      <div class="ml-2" v-if="conflicts_with.length > 0">
        <div
          class="session-conflict mb-1"
          v-for="conflict in conflicts_with" :key="conflict.id"
        >
          <div  v-html="conflict_type_string(conflict, true)"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import sessionConflictMixin from '../store/session_conflict.mixin';
import modelMixin from '../store/model.mixin';
import modelUtilsMixin from "@/store/model_utils.mixin"
import { sessionModel } from '@/store/session.store'
import dateTimeMixin from '../components/date_time.mixin'

const { DateTime } = require("luxon");

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
    conflicts_with: []
  }),
  computed: {
    sessionTitle() {
      // conflicts[0].session.title
      let session = this.get_model(sessionModel, this.sessionId)
      if (session) {
        return session.title
      } else {
        return ''
      }
      // return this.selected_model(sessionModel);
    },
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
    getConflicts(sessionId) {
      this.clear()
      this.get_conflicts({session_id: sessionId}).then(
        (conflicts) => {
          this.conflicts = Object.values(conflicts).filter(
            obj => (typeof obj.json === 'undefined')
          )
        }
      )
      this.get_conflicts_with({session_id: sessionId}).then(
        (conflicts) => {
          this.conflicts_with = Object.values(conflicts).filter(
            obj => (typeof obj.json === 'undefined')
          )
        }
      )
    },
    conflict_type_string(conflict, conflict_with=false) {
      switch(conflict.conflict_type){
        case 'person_exclusion_conflict':
          return `<a href="/people/${conflict.person_id}">${conflict.person_published_name}</a> scheduled against exclusion`
        break;
        case 'availability_conflict':
          return `<a href="/people/${conflict.person_id}">${conflict.person_published_name}</a> is outside of availability`
        break;
        case 'room_conflict':
          let start_time = this.formatLocaleDate(conflict.session_start_time) //DateTime.fromISO(conflict.session_start_time).setZone(this.timezone)
          if (conflict_with) {
            return `${conflict.room_name}<br />
             ${start_time} <br />
             "<a href="/session/${conflict.conflict_session_id}">${conflict.conflict_session_title}</a>"
             overlaps with  <br />
             "<a href="/session/${conflict.session_id}">${conflict.session_title}</a>"`
          } else {
            return `${conflict.room_name}<br />
            ${start_time} <br />
            "<a href="/session/${conflict.session_id}">${conflict.session_title}</a>"
            overlaps with  <br />
            "<a href="/session/${conflict.conflict_session_id}">${conflict.conflict_session_title}</a>"`
          }
        break;
        case 'person_schedule_conflict':
          return `<a href="/people/${conflict.person_id}">${conflict.person_published_name}</a>  is double booked with
                 "<a href="/session/${conflict.conflict_session_id}">${conflict.conflict_session_title}</a>"`
        break;
        case 'person_back_to_back':
          if (conflict_with) {
            return `<a href="/people/${conflict.person_id}">${conflict.person_published_name}</a> has back to back with
                   "<a href="/session/${conflict.conflict_session_id}">${conflict.conflict_session_title}</a>"
                   and "<a href="/session/${conflict.session_id}">${conflict.session_title}</a>"`
          } else {
            return `<a href="/people/${conflict.person_id}">${conflict.person_published_name}</a> has back to back with
                   "<a href="/session/${conflict.session_id}">${conflict.session_title}</a>"
                   and "<a href="/session/${conflict.conflict_session_id}">${conflict.conflict_session_title}</a>"`
          }
        break;
        default:
          return `Some conflict ${conflict}`
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
