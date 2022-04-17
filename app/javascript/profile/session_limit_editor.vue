<template>
  <div v-if="my_limit">
    <validation-provider
      :rules="rules"
      name="Limit"
      :skipIfEmpty="true"
      v-slot="{ valid, errors }"
    >
      <!-- Validate works if the type is text, if type is number then it does not -->
      <input
        v-model="my_limit.max_sessions"
        type='text'
        maxlength="4" size="4"
        @blur="onChange"
        :state="calcValid(errors,valid)"
      />
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
  model: {
    prop: 'person'
  },
  props: {
    person: {
      type: Object,
      required: true
    },
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
    },
    rules: "numeric"
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
    calcValid(errors, valid) {
      if (this.rules == '') {
        return null
      }

      return errors[0] ? false : null //(valid ? true : null)
    },
    onChange($event) {
      // console.log('event', $event)
      // console.log('my limit', this.my_limit)
      if (!this.my_limit.max_sessions && this.my_limit.id) {
        this.my_limit.max_sessions = null;
        this.save(this.my_limit).then((data) => {
          this.my_limit = data
          return;
        })
      } else {
        const num = Number(this.my_limit.max_sessions);
        if (Number.isInteger(num) && num >= 0) {
          if (this.my_limit.id) {
            this.my_limit.max_sessions = num
            this.save(this.my_limit).then(
              (data) => {
                this.my_limit = data
              }
            )
          } else {
            let candidate = {
              person_id: this.person.id,
              day: this.day,
              max_sessions: num
            }
            this.create_session_limit(candidate).then(
              (data) => {
                // console.log('data coming back from create', data)
                this.my_limit = data
              }
            )
          }
        }
      }
    }
  },
  mounted() {
    let existingLimit = null;
    if (!this.day) {
      existingLimit = Object.values(this.$store.getters['jv/get']({_jv: {
          type: 'session_limit',
        }}, `$[?(@.person_id=='${this.person.id}' && !@.day)]`))[0];
    } else {
      existingLimit = Object.values(this.$store.getters['jv/get']({_jv: {
          type: 'session_limit',
        }}, `$[?(@.person_id=='${this.person.id}' && @.day=='${this.day}')]`))[0];
    }
    if (existingLimit) {
      this.my_limit = existingLimit;
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
