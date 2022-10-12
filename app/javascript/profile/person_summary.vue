<template>
    <div :class="['container-fluid', {'my-3': !readOnly}]" v-if="selected">
      <div class="row">
        <div class="col-8">
          <h3>{{selected.published_name}}<edit-button v-b-modal.person-top-modal v-if="!readOnly"></edit-button></h3>
          <div>
            Pronouns: <em>{{selected.pronouns}}</em>
          </div>
          <div>
            Willing to moderate sessions: <em>{{willing_to_moderate}}</em>
          </div>
          <div>
            Primary email: <em v-if="selected.primary_email">{{selected.primary_email.email}}</em>
          </div>
        </div>
        <div class="d-flex flex-column col-4 align-items-end">
            <small>Last Login: {{formatLocaleDate(selected.current_sign_in_at)}}</small>
            <b-button v-if="currentUserIsAdmin && airmeetEnabled" variant="warning" :disabled="!selected.integrations.airmeet" @click="resyncAirmeet" class="mt-2">Airmeet re-sync completed</b-button>
        </div>
      </div>
      <person-edit-modal id="person-top-modal" body-class="formscroll" :person="selected" :data="editData" :validate="true">
        <template #modal-title>Edit Profile - {{selected.published_name}}</template>
        <template #default="{fields}">
          <validation-provider
            name="Name"
            rules="required"
            v-slot="{errors, dirty, validated, valid}"
          >
          <b-form-group label="Name">
            <b-form-input 
              type="text" 
              v-model="fields.name" 
              aria-describedby="name-invalid-feedback"
              :state="dirty || validated ? valid ? null : false : null"
              required
            ></b-form-input>
            <b-form-invalid-feedback id="name-invalid-feedback">{{errors[0]}}</b-form-invalid-feedback>
          </b-form-group>
          </validation-provider>
          <validation-provider name="Pseudonym">
            <b-form-group label="Pseudonym">
              <b-form-input type="text" v-model="fields.pseudonym"></b-form-input>
            </b-form-group>
          </validation-provider>
          <validation-provider name="Pronouns">
            <b-form-group label="Pronouns">
              <b-form-input type="text" v-model="fields.pronouns"></b-form-input>
            </b-form-group>
          </validation-provider>
          <validation-provider name="Willing to moderate">
            <b-form-group>
              <b-form-checkbox switch v-model="fields.willing_to_moderate">Willing to moderate session</b-form-checkbox>
            </b-form-group>
          </validation-provider>
        </template>
      </person-edit-modal>
    </div>
</template>

<script>
const { DateTime } = require("luxon");
import EditButton from '@/components/edit_button';
import PersonEditModal from './person_edit_modal';
import { modelMixinNoProp } from '@/store/model.mixin';
import { personEndpoints, personModel } from '@/store/person.store';
import {PERSON_NEVER_LOGGED_IN} from "@/constants/strings";
import { toastMixin, personSessionMixin } from '@/mixins';
import { airmeetMixin } from '@/integrations/airmeet.mixin';
import {ValidationProvider} from 'vee-validate';

export default {
  name: "PersonSummary",
  props: {
    readOnly: {
      type: Boolean,
      default: false
    }
  },
  components: {
    EditButton,
    PersonEditModal,
    ValidationProvider,
  },
  data: () => ({
    editData: {
      name: null,
      pseudonym: null,
      pronouns: null,
      willing_to_moderate: null
    },
    model: personModel
  }),
  mixins: [
    modelMixinNoProp,
    personSessionMixin,
    toastMixin,
    airmeetMixin
  ],
  computed: {
    willing_to_moderate() {
      return this.selected.willing_to_moderate ? 'Yes' : 'No'
    }
  },
  methods: {
    formatLocaleDate(date, config=DateTime.DATETIME_FULL) {
      if(!date)
        return PERSON_NEVER_LOGGED_IN;
      let d = new Date(date)
      return DateTime.fromJSDate(d).toLocaleString(config)
    },
    scrollToBottom() {
      const el = document.getElementsByClassName('formscroll')[0];
      console.log(el, el.scrollTop, el.scrollHeight);
      el.scrollTop = el.scrollHeight
    },
    log(e) {
      console.log(e)
      console.log(this.editData)
    },
    resyncAirmeet() {
      this.toastPromise(this.$store.dispatch('jv/get', `${personEndpoints[personModel]}/${this.selected.id}/resync_airmeet`), "Successfully updated airmeet sync data.")
    }
  }
}
</script>

<style>

</style>
