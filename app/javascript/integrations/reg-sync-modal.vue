<template>
  <div>
    <b-button v-b-modal.reg-sync-modal variant="link"
      ><b-badge pill variant="warning" style="font-size: 14px">{{
        possibleMatchCount
      }}</b-badge>
      <b-spinner variant="warning" v-if="loading" small></b-spinner>
      Review potential matches</b-button
    >

    <plano-modal
      id="reg-sync-modal"
      size="xl"
      title="Registration Sync Management"
      ok-only
      ok-title="Close"
      headerBgVariant="primary"
      headerTextVariant="light"
      @hide="fetchMatchCount()"
    >
      <person-sync-table></person-sync-table>
    </plano-modal>
  </div>
</template>

<script>
import PlanoModal from "@/components/plano_modal.vue";
import PersonSyncTable from "@/registrations/person_sync_table.vue";
import { FETCH_MATCH_COUNT } from "@/store/person_sync_datum.store";
import { mapActions, mapState } from "vuex";

export default {
  name: "RegSyncModal",
  components: {
    PlanoModal,
    PersonSyncTable,
  },
  data: () => ({
    loading: false
  }),
  computed: {
    ...mapState(["possibleMatchCount"]),
  },
  methods: {
    ...mapActions({
      fetchMatchCount: FETCH_MATCH_COUNT,
    }),
  },
  mounted() {
    this.loading = true;
    this.fetchMatchCount().then(() => {
      this.loading = false;
    })
  },
};
</script>

<style lang="scss">
#reg-sync-modal {
  min-height: calc(100% - 6.75rem);
  max-height: calc(100% - 6.75rem);
  margin: 1.75rem auto 5rem;
  .modal-content {
    min-height: 100%;
    max-height: 100%;
  }
}
</style>
