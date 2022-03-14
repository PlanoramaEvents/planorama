<template>
  <div class="admin scrollable">
    <h1>Admin stuff goes here.  <b-icon-minecart-loaded></b-icon-minecart-loaded></h1>
    <div class="accordion" role="tablist">
      <admin-accordion id="add-user-accordion" title="Add User">
        <person-add></person-add>
      </admin-accordion>
      <admin-accordion id="import-users-accordion" title="Import Users">
        <sheet-importer-vue
          title="Import People"
          import-url="/person/import"
          example-url="/examples/people_import.xlsx"
        >
          <template v-slot:import-details="result">
            Imported: {{result.importMessage.imported}} Skipped {{result.importMessage.skipped}}<br />
            Malformed email: {{result.importMessage.bad_email}}<br />
            Duplicate email: {{result.importMessage.duplicate_email}}<br />
            No name: {{result.importMessage.noname}}
          </template>
        </sheet-importer-vue>
      </admin-accordion>
      <admin-accordion id="edit-roles-accordion" title="Edit Groups" @show="showPeopleRoles">
        <change-user-roles model="person" ref="role-manager"></change-user-roles>
      </admin-accordion>
      <admin-accordion id="import-sessions-accordion" title="Import Sessions">
        <sheet-importer-vue
          title="Import Sessions"
          import-url="/session/import"
          example-url="/examples/session_import.xlsx"
        >
          <template v-slot:import-details="result">
            Imported: {{result.importMessage.imported}} Skipped {{result.importMessage.skipped}}<br />
            No Title: {{result.importMessage.no_title}}<br />
            Duplicate Session: {{result.importMessage.duplicate_session}}<br />
          </template>
        </sheet-importer-vue>
      </admin-accordion>
      <admin-accordion id="mailings-accordion" title="Mailings" @show="showMailings">
        <mailings-manager
          model="mailing"
          ref="mailing-manager"
        ></mailings-manager>
      </admin-accordion>
      <admin-accordion id="event-settings-accordion" title="Event Settings" @show="showConfigs">
        <configurations-manager
          model="parameter_name"
          ref="configurations-manager"
        ></configurations-manager>
      </admin-accordion>
      <admin-accordion id="agreements-accordion" title="Agreements" @show="showAgreements">
        <agreement-manager
          model="agreement"
          ref="agreements-manager"
        ></agreement-manager>
      </admin-accordion>
    </div>
  </div>
</template>

<script>
import AdminAccordion from './admin_accordion.vue'
import PersonAdd from '../people/person_add.vue';
import ChangeUserRoles from './change-user-roles';
import MailingsManager from '../mailings/mailings_manager';
import ConfigurationsManager from '../configurations/configurations_manager';
import SheetImporterVue from '../components/sheet_importer_vue.vue';
//import AgreementAdd from '../agreements/agreement_editor';
//import AgreementTable from "@/agreements/agreement_table";
import AgreementManager from "@/agreements/agreement_manager";

export default {
  components: {
    AgreementManager,
    AdminAccordion,
    PersonAdd,
    ChangeUserRoles,
    SheetImporterVue,
    MailingsManager,
    ConfigurationsManager,
  },
  name: 'AdminComponent',
  data: () => ({
    customization: {
      email: null,
      phone: null,
      ethics: null
    }
  }),
  methods: {
    showMailings() {
      this.$refs['mailing-manager'].init()
    },
    showPeopleRoles() {
      this.$refs['role-manager'].init()
    },
    showConfigs() {
      this.$refs['configurations-manager'].init()
    },
    showAgreements() {
      this.$refs['agreements-manager'].init()
    }
  }
}
</script>

<style lang="scss" scoped>
.accordion {
  max-width: 60rem;
}
</style>
