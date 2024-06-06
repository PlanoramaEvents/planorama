<template>
  <div class="container-fluid scrollable">
    <h1>Registration Sync Management</h1>
    <b-button variant="primary" size="sm" v-b-modal.confirm-reg-sync>Registration Synchronize</b-button>
    <!--  -->
    <!-- <h2>Registration Info (from Reg/clyde)</h2> -->
    <person-sync-table></person-sync-table>

    <!--  -->
    <plano-modal id="confirm-reg-sync" @ok="synchronizeSchedule()">
      <template #modal-title>Synchonize Registration Info</template>
    </plano-modal>
  </div>
</template>

<script>
import PlanoModal from '@/components/plano_modal.vue';
import { toastMixin } from '@/mixins';
import { http } from '@/http';
import PersonSyncTable from "@/registrations/person_sync_table.vue"

export default {
  name: "AdminRegistrations",
  components: {
    PlanoModal,
    PersonSyncTable
  },
  mixins: [
    toastMixin
  ],
  methods: {
    synchronizeSchedule() {
      this.toastPromise(http.get('/registration_sync_data/synchronize'), "Succesfully requested registration sync")
    },
  },
}
</script>

<style>

</style>
