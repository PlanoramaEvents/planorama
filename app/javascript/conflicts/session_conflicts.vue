<template>
  <div class="session-conflicts">
    <div class="session-conflicts-list" v-if="conflicts.length > 0">
      <div v-if="displaySessionInfo">
        <strong>{{conflicts[0].session.title}}</strong><br />
        {{ formatLocaleDate(conflicts[0].session.start_time )}}
      </div>
      <div class="ml-2">
        <div
          class="session-conflict mb-1"
          v-for="conflict in conflicts" :key="conflict.id"
        >
          <div>
            <span v-if="conflict.person"><router-link :to="'/people/availability/' + conflict.person.id">{{conflict.person.published_name}}</router-link></span>
            {{conflict_type_string(conflict.conflict_type, conflict.person, conflict.session, conflict.room)}}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import sessionConflictMixin from '../store/session_conflict.mixin';
import modelMixin from '../store/model.mixin';
import dateTimeMixin from '../components/date_time.mixin'
import { CONFLICT_TEXT } from '@/constants/strings';

export default {
  name: "SessionConflicts",
  mixins: [
    modelMixin,
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
    conflicts: []
  }),
  watch: {
    sessionId(newVal, oldVal) {
      if (newVal) {
        this.getConflicts(newVal)
      } else {
        this.conflicts = []
      }
    }
  },
  methods: {
    getConflicts(sessionId) {
      this.get_conflicts({session_id: sessionId}).then(
        (conflicts) => {
          this.conflicts = Object.values(conflicts).filter(
            obj => (typeof obj.json === 'undefined')
          )
        }
      )
    },
    conflict_type_string(conflict_type, person, session, room) {
      return CONFLICT_TEXT[conflict_type](person?.published_name, session?.title, room?.name) || CONFLICT_TEXT.default;
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
