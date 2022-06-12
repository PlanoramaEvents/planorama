<template>
  <div class="session-conflicts">
    <div class="session-conflicts-list" v-if="conflicts.length > 0">
      <strong>{{conflicts[0].session.title}}</strong><br />
      {{ formatLocaleDate(conflicts[0].session.start_time )}}
      <div
        class="session-conflict mb-1"
        v-for="conflict in conflicts" :key="conflict.id"
      >
        <div>
          <router-link :to="'/people/availability/' + conflict.person.id">{{conflict.person.published_name}}</router-link>
          {{conflict_type_string(conflict.conflict_type)}}
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import sessionConflictMixin from '../store/session_conflict.mixin';
import modelMixin from '../store/model.mixin';
import dateTimeMixin from '../components/date_time.mixin'

export default {
  name: "SessionConflicts",
  mixins: [
    modelMixin,
    dateTimeMixin,
    sessionConflictMixin
  ],
  props: {
    sessionId: null
  },
  data: () =>  ({
    conflicts: []
  }),
  watch: {
    sessionId(newVal, oldVal) {
      console.debug("SEssion id set")
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
    conflict_type_string(conflict_type) {
      switch (conflict_type) {
        case 'availability':
          return "outside of availability"
          break;
        default:
          return "a conflict"
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

.session-conflict {
  border: 1px solid rgba(0,100,150,.15);
  padding: .2em .4em;
}
</style>
