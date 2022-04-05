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
      <div v-for="email in additional">
        <email-address-editor
          v-bind:value="email"
          @input="onInput(email)"
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
      emails: [],
      additional: []
    }
  },
  computed: {
    primary: {
      get: function() {
        if (this.person.email_addresses) {
          let p = Object.values(this.emails).find(em => em.isdefault);
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
            this.setLists()
          }
        )
      } else {
        this.addEmail(arg).then(
          () => {
            this.setLists()
          }
        )
      }
    },
    setLists() {
      this.fetch_model_by_id(
        'person',
        this.person.id
      ).then(data => {
        this.emails = Object.values(data.email_addresses)
        this.additional = this.emails.filter(em => !em.isdefault)
      })
    },
    onNew() {
      this.additional.push({email: '', isdefault: false, person_id: this.currentUser.id})
    }
  },
  mounted() {
    this.emails = Object.values(this.person.email_addresses)
    if (!this.emails) {
      this.emails = []
    } else {
      this.additional = this.emails.filter(em => !em.isdefault)
    }
  }
}
</script>
