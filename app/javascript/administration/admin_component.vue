<template>
  <div class="admin scrollable">
    <h1>Admin stuff goes here.  <b-icon-minecart-loaded></b-icon-minecart-loaded></h1>
    <div class="accordion" role="tablist">
      <admin-accordion id="add-user-accordion" title="Add User">
        <add-user></add-user>
      </admin-accordion>
      <admin-accordion id="import-users-accordion" title="Import Users">
        <b-card-text>Import all the users!!!1!</b-card-text>
      </admin-accordion>
      <admin-accordion id="edit-roles-accordion" title="Edit Roles">
        <b-card-text>Role me, baby.</b-card-text>
      </admin-accordion>
      <admin-accordion id="event-settings-accordion" title="Event Settings" :dirty="event_settings_dirty">
        <b-form-group
          label="Event Email"
          label-for="support-email"
        >
          <b-form-input id="support-email" type="text" v-model="configuration.event_email.parameter_value"></b-form-input>
        </b-form-group>
        <b-form-group
          label="Event Phone Number"
          label-for="support-phone"
        >
          <b-form-input id="support-phone" type="text" v-model="configuration.event_phone.parameter_value"></b-form-input>
        </b-form-group>
        <b-form-group
          label="Event Ethics Agreement"
          label-for="event-ethics"
          description="If you save a new event agreement, you will clear the flag and everyone has to recheck the box."
        >
          <b-form-textarea id="event-ethics" type="text" v-model="information_ethics.terms"></b-form-textarea>
        </b-form-group>
        <div class="d-flex justify-content-end">
          <b-button variant="link" @click="cancel">Revert all fields</b-button>
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
import AddUser from './add-user.vue';

const ADMIN_CONFIGS = (x) => ['event_email', 'event_phone'].includes(x)

export default {
  components: { 
    AdminAccordion,
    AddUser,
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
    ...mapState('configuration', {
      configuration: state =>  state.collection
    }),
    ...mapState('agreements', ['information_ethics']),
    event_settings_dirty() {
      return this.configuration.changed(ADMIN_CONFIGS)
    }
  },
  methods: {
    cancel() {
      this.configuration.reset(ADMIN_CONFIGS);
      this.information_ethics.reset();
    },
    save() {
      this.configuration.save(ADMIN_CONFIGS);
      this.information_ethics.save();
    }
  },
  mounted() {
    this.configuration.fetch();
    this.information_ethics.fetch();
  }
}
</script>

<style lang="scss" scoped>
.accordion {
  max-width: 60rem;
}
</style>
