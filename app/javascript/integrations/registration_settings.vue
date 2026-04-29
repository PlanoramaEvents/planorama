<template>
  <div class="container-fluid">
    <div class="row">
      <div class="column flex-grow-1">
        <h4 class="mt-3 mb-2">Registration Sync Management</h4>
        <div class="d-flex justify-content-between m-2">
        <b-button :disabled="!registrationEnabled" variant="primary" size="sm" v-b-modal.confirm-reg-sync>Run Registration Data Sync</b-button>
        <reg-sync-modal></reg-sync-modal>
        </div>
        <ul class="list-unstyled ml-2 mb-2">
        <li>Last completed full sync: {{ lastSync }}</li>
        <li>Records matched: {{ stats.matched }}</li>
        <li>Records updated: {{ stats.updated }}</li>
        <li>Records not found: {{ stats.not_found }}</li>
        </ul>
        <h4 class="mt-3">Configuration</h4>
        <!-- TODO -->
        <b-form-group label-cols="auto" label="Enable Registration" class="configuration enable ml-2">
          <b-form-checkbox switch v-model="registrationEnabled" @change="patchRegistrationConfig()"></b-form-checkbox>
        </b-form-group>
        <b-form-group label-cols="auto" label="Use a Registration Integration" class="configuration enable ml-2">
          <b-form-checkbox switch v-model="registrationReg" @change="patchRegistrationConfig()" :disabled="!registrationEnabled"></b-form-checkbox>
        </b-form-group>
        <b-form-group label="Base URL for Registration" class="ml-2">
          <b-form-input type="text" v-model="registrationBaseUrl" @blur="patchRegistrationConfig()" :disabled="!registrationEnabled"></b-form-input>
        </b-form-group>
      </div>
    </div>
    <plano-modal id="confirm-reg-sync" @ok="synchronizeSchedule()">
      <template #modal-title>Run Registration Data Sync</template>
      This will sync with the Registration system's data. It will bring the server down for a short time.
      Please double check that you wish to perform this action.
    </plano-modal>
  </div>
</template>

<script>
import { registrationMixin } from './registration.mixin'
import PlanoModal from '@/components/plano_modal.vue';
import { toastMixin } from '@/mixins';
import { http } from '@/http';
import { registrationSyncStatsMixin} from '@/store/registration_sync_stats.mixin';
import RegSyncModal from './reg-sync-modal.vue';

export default {
  name: "RegistrationSettings",
  mixins: [registrationMixin, toastMixin, registrationSyncStatsMixin],
  components: {
    PlanoModal,
    RegSyncModal
  },
  methods: {
    synchronizeSchedule() {
      this.toastPromise(http.get('/registration_sync_data/synchronize'), "Succesfully requested registration sync").then(() => {
        this.fetchStats();
      })
    },
  },
  mounted() {
    this.fetchStats();
  }
}
</script>

<style lang="scss">
.configuration.enable .form-row {
  align-items: center;
}
.basis-14 {
  flex-basis: 14rem;
}
</style>

