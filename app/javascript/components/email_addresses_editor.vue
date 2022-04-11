<template>
  <div>
    <div class="d-flex flex-row w-100">
      <div class="w-75 mt-2 mr-3">
        <b>Email</b>
      </div>
      <div class="mt-2 pt-1 w-25 ooch-left">
        Make Primary
      </div>
    </div>
    <div v-if="primary" class="mt-3">
      Primary email (login)
      <email-address-editor
        v-bind:value="primary"
        :can-delete="false"
        @input="onInput"
        :disabled="disabled"
      ></email-address-editor>
    </div>
    <div class="mt-3">
      Additional Emails
      <div v-for="email in additional" :key="email">
        <email-address-editor
          v-bind:value="email"
          @delete="onDelete(email)"
          @input="onInput(email)"
          :disabled="disabled"
        ></email-address-editor>
      </div>
    </div>
    <b-button @click="onNew" variant="primary" title="New" class="mt-2" size="sm">
      <b-icon-plus></b-icon-plus>
    </b-button>
  </div>
</template>

<script>

import EmailAddressEditor from './email_address_editor.vue'
import emailAddressMixin from '../store/email_address.mixin'
import {personSessionMixin} from '@/mixins';
import modelUtilsMixin from "@/store/model_utils.mixin";

export default {
  name: 'EmailAddressesEditor',
  components: {
    EmailAddressEditor
  },
  mixins: [
    modelUtilsMixin,
    emailAddressMixin,
    personSessionMixin
  ],
  model: {
    prop: 'person',
    // event: 'blur'
  },
  props: {
    person: null,
    loading: {
      type: Boolean,
      default: false
    },
    disabled: false
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
    onDelete(arg) {
      if (arg.id) {
        this.delete_model_by_id('email_address', arg.id).then(
          () => {
            this.setLists()
          }
        )
      }
    },
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
        this.$emit('input', data)
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
<style scoped lang="scss">
.ooch-left {
  margin-left: -3rem;
}
</style>
