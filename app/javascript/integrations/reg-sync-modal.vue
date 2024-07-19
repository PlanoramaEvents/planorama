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
      title="Registration Sync Management"
      ok-only
      ok-title="Close"
      headerBgVariant="primary"
      headerTextVariant="light"
      @hide="onHide()"
      :no-close-on-backdrop="true"
      :no-close-on-esc="false"
    >
      <div class="mb-2">
        <div class="small">Last completed full sync: {{ lastSync }}</div>
        <b-spinner v-if="modalLoading" variant="primary"></b-spinner>
        <div v-if="selected">
          People with potential matches: {{ fullTotal }}
        </div>
      </div>
      <div v-if="!fullTotal && !modalLoading">
        <span class="text-muted font-italic">No more people to match!</span>
      </div>
      <div v-if="selected">
        <div class="mb-2 d-flex align-items-center">
          <icon-button
            @click="alsoHideTooltip(selectPrev)"
            icon="caret-left-fill"
            tooltip="Previous"
            :disabled="selectedOrdinal === 1"
            disabledTooltip="No previous person"
          ></icon-button>
          <h5 class="name-span mb-0">{{ selected.published_name }}</h5>
          <icon-button
            @click="alsoHideTooltip(selectNext)"
            icon="caret-right-fill"
            tooltip="Next"
            :disabled="selectedOrdinal === fullTotal"
            disabledTooltip="No next person"
          ></icon-button>
          <reg-sync-person-search
            @personSelected="select($event)"
          ></reg-sync-person-search>
        </div>
        <h6>Planorama Data</h6>
        <div class="mb-3 ml-2">
          <div>Email: {{ selected.primary_email.email }}</div>
          <div>Published Name: {{ selected.published_name }}</div>
          <div>Name: {{ selected.name }}</div>
        </div>
        <h5>Potential Matches (from registration system)</h5>
        <div
          v-if="Object.keys(selected.registration_sync_data).length"
          class="scrollable-region"
        >
          <ol>
            <li
              v-for="(reg_data, _, index) in selected.registration_sync_data"
              :key="reg_data.id"
            >
              <div
                v-if="index !== 0"
                style="border-bottom: 1px solid black"
                class="w-75 my-3"
              ></div>
              <div class="d-flex justify-content-between">
                <div>
                  <display-sync-data :regData="reg_data"></display-sync-data>
                </div>
                <div class="d-flex flex-column justify-content-center mr-3">
                  <b-button
                    variant="primary"
                    @click="matchAndNext(reg_data.reg_id, selected.id)"
                    >Match</b-button
                  >
                  <spinner-button
                    variant="primary"
                    class="mt-2"
                    @click="dismissAndRefresh(reg_data.reg_id, selected.id, index + 1)"
                    :showButtonTextWhileLoading="true"
                    :loading="dismissInProgress === index + 1"
                    >Dismiss</spinner-button
                  >
                </div>
              </div>
            </li>
          </ol>
        </div>
        <div v-else>
          <span class="font-italic text-muted"
            >There are no more potential matches.</span
          >
        </div>
      </div>
    </plano-modal>
  </div>
</template>

<script>
import PlanoModal from "@/components/plano_modal.vue";
import { modelMixinNoProp } from "@/mixins";
import DisplaySyncData from "@/registrations/display_sync_data.vue";
import {
  FETCH_MATCH_COUNT,
  personSyncDatumModel as model,
} from "@/store/person_sync_datum.store";
import { registrationSyncStatsMixin } from "@/store/registration_sync_stats.mixin";
import { mapActions, mapState } from "vuex";
import { personSyncDatumMixin } from "@/store/person_sync_datum.mixin";
import IconButton from "@/components/icon_button.vue";
import RegSyncPersonSearch from "./reg-sync-person-search.vue";
import SpinnerButton from "@/shared/spinner-button.vue";

export default {
  name: "RegSyncModal",
  components: {
    PlanoModal,
    DisplaySyncData,
    IconButton,
    RegSyncPersonSearch,
    SpinnerButton
  },
  mixins: [modelMixinNoProp, registrationSyncStatsMixin, personSyncDatumMixin],
  data: () => ({
    loading: false,
    modalLoading: false,
    model,
    dismissInProgress: false,
  }),
  computed: {
    ...mapState(["possibleMatchCount"]),
  },
  methods: {
    ...mapActions({
      fetchMatchCount: FETCH_MATCH_COUNT,
    }),
    dismissAndRefresh(regId, personId, idx) {
      this.dismissInProgress = idx;
      this.dismissMatch(regId, personId).then(() => {
        this.dismissInProgress = false;
        this.fetchSelected();
      });
    },
    matchAndNext(regId, personId) {
      this.assistedMatch(regId, personId).then(() => {
        if (this.selectedOrdinal === this.fullTotal) {
          if (this.selectedOrdinal === 1) {
            // fetch everything because this was the last one
            // this should then display no more matches
            this.unselect();
            this.fetch();
          } else {
            // this is the last one but there are previous
            this.selectPrev().then(() => {
              // fix the ordinal
              this.fetch();
            });
          }
        } else {
          this.selectNext().then(() => {
            // fix the ordinal
            this.fetch();
          });
        }
      });
    },
    alsoHideTooltip(target) {
      target();
      this.$root.$emit("bv::hide::tooltip");
    },
    onHide() {
      this.fetchMatchCount();
      this.modalLoading = true;
      this.fetch().then(() => {
        this.selectFirst();
        this.modalLoading = false;
      });
    },
  },
  mounted() {
    this.loading = true;
    this.modalLoading = true;
    this.fetchMatchCount().then(() => {
      this.loading = false;
    });
    this.fetch().then(() => {
      this.selectFirst();
      this.modalLoading = false;
    });
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

.name-span {
  min-width: 16rem;
  text-align: center;
}

.scrollable-region {
  max-height: 332px;
  overflow-y: scroll;
}
</style>
