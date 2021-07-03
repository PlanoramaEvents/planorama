<template>
  <div class="admin">
    <h1>Admin stuff goes here.  <b-icon-minecart-loaded></b-icon-minecart-loaded></h1>
    <div class="accordion" role="tablist">
      <admin-accordion id="add-user-accordion" title="Add User">
        <b-card-text>Someday you will be able to add a user here</b-card-text>
      </admin-accordion>
      <admin-accordion id="import-users-accordion" title="Import Users">
        <b-card-text>Import all the users!!!1!</b-card-text>
      </admin-accordion>
      <admin-accordion id="edit-roles-accordion" title="Edit Roles">
        <b-card-text>Role me, baby.</b-card-text>
      </admin-accordion>
      <admin-accordion id="event-settings-accordion" title="Event Settings">
        <b-form-group
          label="Event Email"
          label-for="support-email"
        >
          <b-form-input id="support-email" type="text" v-model="configuration.event_email"></b-form-input>
        </b-form-group>
        <b-form-group
          label="Event Phone Number"
          label-for="support-phone"
        >
          <b-form-input id="support-phone" type="text" v-model="configuration.event_phone"></b-form-input>
        </b-form-group>
        <b-form-group
          label="Event Ethics Agreement"
          label-for="event-ethics"
          description="If you save a new event agreement, you will clear the flag and everyone has to recheck the box."
        >
          <b-form-textarea id="event-ethics" type="text" v-model="customization.ethics"></b-form-textarea>
        </b-form-group>
        <div class="d-flex justify-content-end">
          <b-button variant="link" @click="cancel">Cancel</b-button>
          <b-button variant="primary" @click="save">Save</b-button>
        </div>
      </admin-accordion>
    </div>
  </div>
</template>

<script>
import AdminAccordion from './admin_accordion.vue'
import { mapState } from 'vuex';
import { SAVE, UPDATED } from '../model.store';
import { Configuration } from './configurations';

export default {
  components: { 
    AdminAccordion
  },
  name: 'AdminComponent',
  data: () => ({
    customization: {
      email: null,
      phone: null,
      ethics: null
    }
  }),
  computed: {
    ...mapState({
      configuration: 'collection'
    }),
  },
  methods: {
    cancel() {
      // TODO reset
    },
    save() {
      console.log("I should do something here", this.configuration)
      this.configuration.save()
    }
  },
  mounted() {
    this.configuration.makeComputed('event_email');
    this.configuration.makeComputed('event_phone');
    this.configuration.fetch();
  }
}
</script>

<style lang="scss" scoped>
.accordion {
  max-width: 60rem;
}
</style>
