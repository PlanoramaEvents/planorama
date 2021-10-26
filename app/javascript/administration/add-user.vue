<template>
  <b-form>
    <model-field label="Name" v-model="person.name" type="text" stateless></model-field>
    <email-field label="Email" id="new-user-email" v-model="email"></email-field>
    <div class="d-flex justify-content-end">
      <!-- TODO: Cancel does nothing (in old and new code) -->
      <b-button variant="link" @click="cancel">Cancel</b-button>
      <b-button variant="primary" @click="save">Save</b-button>
    </div>
  </b-form>
</template>

<script>
// import { Person } from '../people/people'
import toastMixin from '../toast-mixin';
import { ADMIN_ADD_USER_SUCCESS } from '../constants/strings';
import ModelField from '../model-field';
import EmailField from '../shared/email_field';

export default {
  name: "AddUser",
  components: {
    ModelField,
    EmailField,
  },
  mixins: [toastMixin],
  data: () =>  ({
    // This is minimal JSON for a new Person entity
    person: {
      name: '',
      email_addresses_attributes: [
        {
          isdefault: true,
          email: ''
        }
      ]
    },
  }),
  computed: {
    email: {
      get() {
        return this.person.email_addresses_attributes && this.person.email_addresses_attributes[0]?.email;
      },
      set(val) {
        this.person.email_addresses_attributes = [{email: val, isdefault: true}];
      }
    }
  },
  methods: {
    cancel() {
      // reset the fields to be empty...
      this.person.name = '';
      this.person.email_addresses_attributes = [{email: '', isdefault: true}];
    },
    save() {
      // this.person.save()
      //   .then(() => {
      //     this.success_toast(ADMIN_ADD_USER_SUCCESS(this.person.name))
      //     this.person = new Person();
      //   })
      //   .catch((error) => this.error_toast(error.message))
    }
  }
}
</script>

<style>

</style>
