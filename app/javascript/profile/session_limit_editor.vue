<template>
  <div>
    <v-form as="div" ref="limitForm">
      <v-field name="limitfield" type="number" :rules="limitRules" v-slot="{ handleChange, errors }">
        <input
          v-model="limit"
          type='text'
          maxlength="4" size="4"
          @change="(event) => {handleChange(event); onChange(); }"
          :class="{'is-invalid': !!errors.length }"
        />
      </v-field>
      <error-message as="div" name="limitfield" v-slot="{message }">
        <div class="invalid-message">{{ message }}</div>
      </error-message>
    </v-form>
  </div>
</template>

<script>
import { Field as VField, Form as VForm, ErrorMessage } from 'vee-validate';
import settingsMixin from "@/store/settings.mixin";
import sessionLimitMixin from '../store/session_limit.mixin'
import personSessionMixin from '../auth/person_session.mixin';

export default {
  name: "SessionLimitEditor",
  components: {
    VField,
    VForm,
    ErrorMessage
  },
  mixins: [
    settingsMixin,
    personSessionMixin,
    sessionLimitMixin
  ],
  model: {
    prop: 'session_limit'
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
    my_limit : null,
    limit: null
  }),
  methods: {
    onChange($event) {
      // TODO: make this a merge ... see other examples
      // if (this.limit == '') return;
      this.$refs.limitForm.validate().then(
        (result) => {
          if (result) {
            // update the value 
            if ((typeof this.limit === "string" && this.limit.trim().length === 0)) {
              this.my_limit.max_sessions = null;
            }
            // this.$emit('input', this.value)
            if (!this.limit && this.my_limit.id) {
              this.my_limit.max_sessions = null;
              this.patchSessionLimit(this.my_limit, ['max_sessions']).then((res) => {
                this.my_limit = res
                return;                
              })
            } else {
              const num = Number(this.limit);
              if (Number.isInteger(num) && num >= 0) {
                if (this.my_limit.id) {
                  this.my_limit.max_sessions = num
                  this.patchSessionLimit(this.my_limit, ['max_sessions']).then((res) => {
                    this.my_limit = res
                    return;                
                  })
                } else {
                  let candidate = {
                    person_id: this.person.id,
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
          }
        }
      )
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
      this.limit = this.my_limit.max_sessions
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

<script setup>
import * as yup from 'yup';

const limitRules = yup.string().test(
  'is-number',
  (n) => 'Limit is not valid',
  (value) => value == null || (typeof value === "string" && value.trim().length === 0) || value >= 0,
);
</script>

<style lang="css" scoped>
.invalid-message {
  width: 100%;
  margin-top: 0.25rem;
  font-size: 0.875em;
  color: #dc3545;
}
</style>