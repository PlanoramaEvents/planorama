<template>
<div>
  <b-button v-b-modal.reg-sync-modal variant="link"><b-badge pill variant="warning" style="font-size: 14px">1</b-badge> Review potential matches</b-button>
  
  <plano-modal id="reg-sync-modal"
  size="xl"
  title="Registration Sync Management"
  ok-only
  ok-title="Close"
  headerBgVariant="primary"
  headerTextVariant="light"
  >
    <person-sync-table></person-sync-table>
  </plano-modal>
</div> 
</template>

<script>
import PlanoModal from "@/components/plano_modal.vue"
import PersonSyncTable from "@/registrations/person_sync_table.vue"

export default {
  name: "RegSyncModal",
  components: {
    PlanoModal,
    PersonSyncTable,
  }

}
</script>

<style>
#reg-sync-modal {
  min-height: calc(100% - 6.75rem);
  max-height: calc(100% - 6.75rem);
  margin: 1.75rem auto 5rem;
}
</style>
