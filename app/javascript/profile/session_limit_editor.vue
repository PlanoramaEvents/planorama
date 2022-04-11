<template>
  <b-form-input
    v-model="limit"
    type='number'
    @change="onChange"
    min="0"
  ></b-form-input>
</template>

<script>
import settingsMixin from "@/store/settings.mixin";
import sessionLimitMixin from '../store/session_limit.mixin'
import personSessionMixin from '../auth/person_session.mixin';

export default {
  name: "SessionLimitEditor",
  mixins: [
    settingsMixin,
    personSessionMixin,
    sessionLimitMixin
  ],
  props: {
    day: {
      type: String,
      default: null
    },
    timezone: {
      type: String,
      default: null
    }
  },
  data: () =>  ({
    my_limit: null
  }),
  computed: {
    limit: {
      get: function() {
        let l = null
        if (this.my_limit) {
          l = this.my_limit.max_sessions
        }
        return l
      },
      set: function(l) {
        // ???
      }
    }
  },
  methods: {
    onChange(newVal) {
      // Do not do anything if the value is not a number
      if (!isNaN(parseInt(newVal))) {
        if (this.my_limit) {
          this.my_limit.max_sessions = newVal
          this.save(this.my_limit).then(
            (data) => {
              this.my_limit = data
            }
          )
        } else {
          let candidate = {
            person_id: this.currentUser.id,
            day: this.day,
            max_sessions: newVal
          }
          this.create_session_limit(candidate).then(
            (data) => {
              this.my_limit = data
            }
          )
        }
      }
    }
  },
  mounted() {
    let my_limits =  Object.values(this.currentUser.session_limits)
    let candidate_idx =  my_limits.findIndex((el) => el.day == this.day)
    if (candidate_idx >= 0) {
      this.my_limit = my_limits[candidate_idx]
    }
  }
}
</script>

<style lang="scss">
</style>
