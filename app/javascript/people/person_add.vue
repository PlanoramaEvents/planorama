<template>
  <b-form
    ref='add-person-form'
  >
    <model-field label="Name" v-model="person.name" type="text" stateless></model-field>
    <email-field label="Email" id="new-user-email" v-model="email"></email-field>
    <div class="d-flex justify-content-end" v-if='showButtons'>
      <b-button variant="link" @click="clear">Cancel</b-button>
      <b-button variant="primary" @click="savePerson">Save</b-button>
    </div>
  </b-form>
</template>

<script>
import toastMixin from '@/mixins/toast-mixin';
import { ADMIN_ADD_USER_SUCCESS } from '@/constants/strings';
import ModelField from '@/components/model-field';
import EmailField from '@/components/email_field';

import { mapActions } from 'vuex';
import { NEW_PERSON } from '@/store/person.store';

export default {
  name: "PersonAdd",
  components: {
    ModelField,
    EmailField,
  },
  mixins: [
    toastMixin
  ],
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
  props: {
    showButtons: {
      default: true,
      tyep: Boolean
    }
  },
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
    ...mapActions({newPersonAction: NEW_PERSON}),
    clear() {
      this.person.name = '';
      this.person.email_addresses_attributes = [{email: '', isdefault: true}];
    },
    savePerson() {
      let res = this.newPersonAction(this.person);
      res.then(
        (obj) => {
          this.$bvToast.toast(
            ADMIN_ADD_USER_SUCCESS(obj.name),
            {
              variant: 'success',
              title: 'Person Created'
            }
          )
          this.clear()
        }
      ).catch(
        (err) => {
          this.$bvToast.toast(
            err.response.data.errors[0].title,
            {
              variant: 'danger',
              title: err.response.data.errors[0].title
            }
          )
        }
      );
    }
  }
}
</script>

<style>

</style>
