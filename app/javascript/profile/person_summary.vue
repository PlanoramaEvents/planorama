<template>
  <div class="container my-3" v-if="person">
    <div class="row">
      <div class="col-8">
        <h3>{{person.published_name}}<edit-button v-b-modal.person-top-modal></edit-button></h3>
      </div>
      <div class="col-4 d-flex flex-row-reverse">
          <small>Last Login: {{formatLocaleDate(person.current_sign_in_at)}}</small>
      </div>
    </div>

      <div>
        Pronouns: <em>{{person.pronouns}}</em>
      <div>
        Willing to moderate sessions: <em>{{willing_to_moderate}}</em>
      </div>
      <div>
        Primary email: <em>{{person.primary_email.email}}</em>
      </div>
    </div>
    <person-edit-modal id="person-top-modal" body-class="formscroll" :person="person" :data="editData">
      <template #modal-title>Edit Profile - {{person.published_name}}</template>
      <template #default="slotData">
        <b-form-group label="Name">
          <b-form-input type="text" v-model="slotData.fields.name"></b-form-input>
        </b-form-group>
        <b-form-group label="Pseudonym">
          <b-form-input type="text" v-model="slotData.fields.pseudonym"></b-form-input>
        </b-form-group>
        <b-form-group label="Pronouns">
          <b-form-input type="text" v-model="slotData.fields.pronouns"></b-form-input>
        </b-form-group>
        <b-form-group>
          <b-form-checkbox switch v-model="slotData.fields.willing_to_moderate" @change="log($event)">Willing to moderate session</b-form-checkbox>
        </b-form-group>
      </template>
    </person-edit-modal>
  </div>
</template>

<script>
const { DateTime } = require("luxon");
import EditButton from '@/components/edit_button';
import PersonEditModal from './person_edit_modal';

export default {
  name: "PersonSummary",
  components: {
    EditButton,
    PersonEditModal,
  },
  model: {
    prop: 'person',
    // event: 'blur'
  },
  data: () => ({
    editData: {
      name: null,
      pseudonym: null,
      pronouns: null,
      willing_to_moderate: null
    }
  }),
  props: {
    person: {
      type: Object,
      required: true
    }
  },
  computed: {
    willing_to_moderate() {
      return this.person.willing_to_moderate ? 'Yes' : 'No'
    }
  },
  methods: {
    formatLocaleDate(date, config=DateTime.DATETIME_FULL) {
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
