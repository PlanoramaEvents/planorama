<template>
  <div>
    <b-row class="my-1" v-for="day in days" :key="day">
      <b-col sm="4">
        <b-form-input
          v-model="limits[day]"
          type='number'
          @change="onChange(day)"
        ></b-form-input>
      </b-col>
      <b-col sm="8">
        <label for="input-none">
          {{ formatDate(day, { weekday: 'long' }) }}
        </label>
      </b-col>
    </b-row>
  </div>
</template>

<script>
import settingsMixin from "@/store/settings.mixin";
import sessionLimitMixin from '../store/session_limit.mixin'
import personSessionMixin from '../auth/person_session.mixin';

const { DateTime } = require("luxon");

export default {
  name: "SessionLimits",
  components: {
  },
  mixins: [
    settingsMixin,
    personSessionMixin,
    sessionLimitMixin
  ],
  props: {
    days: {
      type: Array,
      required: true
    },
    timezone: {
      type: String,
      default: null
    }
  },
  data: () =>  ({
    my_limits: []
  }),
  computed: {
    limits: {
      get: function() {
        let l = {}
        for (const limit of this.my_limits) {
          if (limit.day) {
            l[limit.day] = limit.max_sessions
          }
        }
        return l
      }
    }
  },
  methods: {
    onChange(d) {
      // use d to look get the value in limits
      // look at my limits, if there update if not it is new (and we update my limit on return)
      let candidate_idx = this.my_limits.findIndex((el) => el.day == d)
      if (candidate_idx >= 0) {
        this.my_limits[candidate_idx].max_sessions = this.limits[d]
        this.save(this.my_limits[candidate_idx]).then(
          (data) => {
            this.my_limits[candidate_idx] = data
          }
        )
      } else {
        let candidate = {
          person_id: this.currentUser.id,
          day: d,
          max_sessions: this.limits[d]
        }
        this.create_session_limit(candidate).then(
          (data) => {
            this.my_limits.push(data)
          }
        )
      }
    },
    formatDate(date, config) {
      return DateTime.fromISO(date).setZone(this.timezone).toLocaleString(config)
    },
    init: function(arg) {
      this.my_limits = Object.values(this.currentUser.session_limits)
    }
  },
  mounted() {
    this.init()
  }
}
</script>

<style lang="scss">
</style>
