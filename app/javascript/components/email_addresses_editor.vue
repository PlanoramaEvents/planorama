<template>
  <div>
    <div class="d-flex flex-row w-100">
      <div class="w-75 mt-2 mr-3">
        <h5>Email</h5>
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
        :radioGroup="radioGroup"
      ></email-address-editor>
    </div>
    <div class="mt-3">
      Additional Emails
      <div v-for="email in additional" :key="email.id">
        <email-address-editor
          :value="email"
          @delete="onDelete(email)"
          @input="onInput(email)"
          :disabled="disabled"
          :radioGroup="radioGroup"
        ></email-address-editor>
      </div>
    </div>
    <b-button ref="add_email_button" @click="onNew" variant="primary" title="New" class="mt-2" size="sm">
      <b-icon-plus></b-icon-plus>
    </b-button>
    <plano-modal id="primaryEmailConfirm" title="Primary Email Confirmation" @ok="onConfirmOk()" @cancel="onConfirmCancel()" @close="onConfirmCancel()">
      <p>You are about to change the primary email address associated with this profile. <strong>This will change the login email used for this account.</strong></p>
      <p>Are you sure you wish to make this change?</p>
    </plano-modal>
  </div>
</template>

<script>

import EmailAddressEditor from './email_address_editor.vue'
import emailAddressMixin from '../store/email_address.mixin'
import {personSessionMixin} from '@/mixins';
import modelUtilsMixin from "@/store/model_utils.mixin";
import PlanoModal from './plano_modal.vue';

export default {
  name: 'EmailAddressesEditor',
  components: {
    EmailAddressEditor,
    PlanoModal
  },
  mixins: [
    modelUtilsMixin,
    emailAddressMixin,
    personSessionMixin
  ],
  model: {
    prop: 'person',
  },
  props: {
    person: null,
    loading: {
      type: Boolean,
      default: false
    },
    disabled: false,
    id: {
      type: String,
      default: 'email-addresses-editor'
    }
  },
  data: () => ({
    emails: [],
    additional: [],
    pendingPrimaryChange: null
  }),
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
    },
    radioGroup() {
      return `${this.id}-make-primary`;
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
    onConfirmCancel() {
      this.setLists()
      this.pendingPrimaryChange = null;
    },
    onConfirmOk() {
      this.saveEmail(this.pendingPrimaryChange).then(
        () => {
          this.setLists()
        }
      ).catch((err) => {
        console.log("i caught an error", err)
        this.setLists()
      });
      this.pendingPrimaryChange = null;
    },
    onInput(arg) {
      if(arg.isdefault) {
        this.$bvModal.show('primaryEmailConfirm')
        this.pendingPrimaryChange = arg;
        return;
      }
      if (arg.id) {
        this.saveEmail(arg).then(
          () => {
            this.setLists()
          }
        ).catch((err) => {
          console.log("i caught an error", err)
          this.setLists()
        })
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
        // this.$emit('input', data)
      })
    },
    onNew() {
      this.additional.push({email: '', isdefault: false, person_id: this.person.id})
      this.$emit('add')
      this.$refs.add_email_button.scrollIntoView({behavior: 'smooth'});
    }
  },
  mounted() {
    if (this.person.email_addresses) {
      this.emails = Object.values(this.person.email_addresses)
    }
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
