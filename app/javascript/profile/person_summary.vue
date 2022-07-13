<template>
    <div class="container-fluid my-3" v-if="selected">
      <div class="row">
        <div class="col-8">
          <h3>{{selected.published_name}}<edit-button v-b-modal.person-top-modal></edit-button></h3>
        </div>
        <div class="col-4 d-flex flex-row-reverse">
            <small>Last Login: {{formatLocaleDate(selected.current_sign_in_at)}}</small>
        </div>
      </div>

        <div>
          Pronouns: <em>{{selected.pronouns}}</em>
        <div>
          Willing to moderate sessions: <em>{{willing_to_moderate}}</em>
        </div>
        <div>
          Primary email: <em v-if="selected.primary_email">{{selected.primary_email.email}}</em>
        </div>
      </div>
      <person-edit-modal id="person-top-modal" body-class="formscroll" :person="selected" :data="editData">
        <template #modal-title>Edit Profile - {{selected.published_name}}</template>
        <template #default="{fields}">
          <b-form-group label="Name">
            <b-form-input type="text" v-model="fields.name"></b-form-input>
          </b-form-group>
          <b-form-group label="Pseudonym">
            <b-form-input type="text" v-model="fields.pseudonym"></b-form-input>
          </b-form-group>
          <b-form-group label="Pronouns">
            <b-form-input type="text" v-model="fields.pronouns"></b-form-input>
          </b-form-group>
          <b-form-group>
            <b-form-checkbox switch v-model="fields.willing_to_moderate" @change="log($event)">Willing to moderate session</b-form-checkbox>
          </b-form-group>
        </template>
      </person-edit-modal>
    </div>
</template>

<script>
const { DateTime } = require("luxon");
import EditButton from '@/components/edit_button';
import PersonEditModal from './person_edit_modal';
import { modelMixinNoProp } from '@/store/model.mixin';
import { personModel } from '@/store/person.store';
import {PERSON_NEVER_LOGGED_IN} from "@/constants/strings";

export default {
  name: "PersonSummary",
  components: {
    EditButton,
    PersonEditModal,
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
    modelMixinNoProp
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
    }
  }
}
</script>

<style>

</style>
