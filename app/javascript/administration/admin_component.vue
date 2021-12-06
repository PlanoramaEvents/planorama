<template>
  <div class="admin scrollable">
    <h1>Admin stuff goes here.  <b-icon-minecart-loaded></b-icon-minecart-loaded></h1>
    <div class="accordion" role="tablist">
      <admin-accordion id="add-user-accordion" title="Add User">
        <person-add></person-add>
      </admin-accordion>
      <admin-accordion id="import-users-accordion" title="Import Users">
        <!-- TODO - make this inline -->
        <sheet-importer-vue
          title="Import People"
          import-url="/person/import"
        ></sheet-importer-vue>
      </admin-accordion>
      <admin-accordion id="edit-roles-accordion" title="Edit Roles">
        <change-user-roles></change-user-roles>
      </admin-accordion>
      <admin-accordion id="event-settings-accordion" title="Event Settings" :dirty="event_settings_dirty">
        <b-form-group
          label="Event Email"
          label-for="support-email"
        >
          <b-form-input id="support-email" type="text" zz-model="configuration.event_email.parameter_value"></b-form-input>
        </b-form-group>
        <b-form-group
          label="Event Phone Number"
          label-for="support-phone"
        >
          <b-form-input id="support-phone" type="text" zz-model="configuration.event_phone.parameter_value"></b-form-input>
        </b-form-group>
        <b-form-group
          label="Event Ethics Agreement"
          label-for="event-ethics"
          description="If you save a new event agreement, you will clear the flag and everyone has to recheck the box."
        >
          <b-form-textarea id="event-ethics" type="text" zz-model="information_ethics.terms"></b-form-textarea>
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
import { mapActions, mapState } from 'vuex';
import { SAVE, UPDATED } from '../store/model.store';
// import { Configuration } from './configurations';
import PersonAdd from '../people/person_add.vue';
import ChangeUserRoles from './change-user-roles';
import toastMixin from '../shared/toast-mixin';
// import { InformationEthicsAgreement } from './agreement';
// import { FETCH_IEA, SAVE_IEA } from './agreement.store';

import SheetImporterVue from '../components/sheet_importer_vue.vue';

const ADMIN_CONFIGS = (x) => ['event_email', 'event_phone'].includes(x)

export default {
  components: {
    AdminAccordion,
    PersonAdd,
    ChangeUserRoles,
    SheetImporterVue
  },
  mixins: [toastMixin],
  name: 'AdminComponent',
  data: () => ({
    customization: {
      email: null,
      phone: null,
      ethics: null
    }
  }),
  computed: {
    // ...mapState('admin/configuration', {
    //   configuration: state =>  state.collection
    // }),
    // ...mapState('admin/agreements', ['information_ethics']),
    event_settings_dirty() {
      // return this.configuration.changed(ADMIN_CONFIGS)
      return false
    }
  },
  methods: {
    // ...mapActions('admin/agreements', {
    //   fetchIea: FETCH_IEA,
    //   saveIea: SAVE_IEA
    // }),
    cancel() {
      // this.configuration.reset(ADMIN_CONFIGS);
      // this.information_ethics.reset();
    },
    save() {
      // this.configuration.save(ADMIN_CONFIGS);
      // this.saveIea(this.toastSuccessFailure('information ethics saved'))
    }
  },
  mounted() {
    // this.configuration.fetch();
    // this.fetchIea();
  }
}
</script>

<style lang="scss" scoped>
.accordion {
  max-width: 60rem;
}
</style>
