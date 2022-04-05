<template>
  <div>
    <div v-if="primary">
      Primary email (login)
        <email-address-editor
          v-bind:value="primary"
          @input="onInput"
        ></email-address-editor>
    </div>
    <div>
      Additional Emails
      <div v-for="themail in emails">
        <email-address-editor
          v-bind:value="themail"
          @input="onInput(themail)"
        ></email-address-editor>
      </div>
    </div>
    <b-button @click="onNew" variant="primary" title="New" class="mt-2">
      <b-icon-plus scale="2"></b-icon-plus>
    </b-button>
  </div>
</template>

<script>

import EmailAddressEditor from './email_address_editor.vue'
import emailAddressMixin from '../store/email_address.mixin'
import {personSessionMixin} from '@/mixins';

export default {
  name: 'EmailAddressesEditor',
  components: {
    EmailAddressEditor
  },
  mixins: [
    emailAddressMixin,
    personSessionMixin
  ],
  props: {
    person: null,
    loading: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      emails: []
    }
  },
  computed: {
    primary: {
      get: function() {
        if (this.person.email_addresses) {
          let p = Object.values(this.person.email_addresses).find(em => em.isdefault);
          return p
        } else {
          return null
        }
      },
      set: function(val) {
        // console.debug("****** SET", val)
      }
    }
  },
  methods: {
    onInput(arg) {
      if (arg.id) {
        this.saveEmail(arg).then(
          () => {
            this.getEmailsForPerson(this.person).then(
              (data) => {
                this.emails = Object.values(this.person.email_addresses).filter(em => !em.isdefault)
              }
            )
          }
        )
      } else {
        this.addEmail(arg).then(
          () => {
            this.fetchSession({force: true}).then(
              () => {
                this.emails = Object.values(this.person.email_addresses).filter(em => !em.isdefault)
              }
            )
          }
        )
      }
    },
    onNew() {
      this.emails.push({email: '', isdefault: false, person_id: this.currentUser.id})
    }
  },
  mounted() {
    this.emails = Object.values(this.person.email_addresses).filter(em => !em.isdefault)
    if (!this.emails) {
      this.emails = []
    }
  }
}
</script>
