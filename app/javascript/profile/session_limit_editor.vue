<template>
  <div v-if="my_limit">
    <validation-provider
      rules="numeric"
      name="Limit"
      :skipIfEmpty="true"
      v-slot="{ valid, errors }"
    >
      <!-- Validate works if the type is text, if type is number then it does not -->
      <input
        v-model="my_limit.max_sessions"
        type='text'
        maxlength="4" size="4"
        @blur="onChange(my_limit.max_sessions)"
      ></input>
      <div class="invalid-message">{{ errors[0] }}</div>
    </validation-provider>
  </div>
</template>

<script>
import { ValidationProvider, ValidationObserver} from 'vee-validate';
import settingsMixin from "@/store/settings.mixin";
import sessionLimitMixin from '../store/session_limit.mixin'
import personSessionMixin from '../auth/person_session.mixin';

export default {
  name: "SessionLimitEditor",
  components: {
    ValidationProvider,
    ValidationObserver
  },
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
    my_limit: {
      max_sessions: null
    }
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
      // Do not do anything if the value is not a positive number
      const num = Number(newVal);
      if (Number.isInteger(num) && num > 0) {
        if (this.my_limit.id) {
          this.my_limit.max_sessions = num
          this.save(this.my_limit).then(
            (data) => {
              this.my_limit = data
            }
          )
        } else {
          let candidate = {
            person_id: this.currentUser.id,
            day: this.day,
            max_sessions: num
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
    } else {
      this.my_limit = {
        person_id: this.currentUser.id,
        day: this.day,
        max_sessions: null
      }
    }
  }
}
</script>

<style lang="scss">
</style>
