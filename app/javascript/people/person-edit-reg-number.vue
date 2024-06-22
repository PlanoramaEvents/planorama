<template>
  <div>
    <edit-modal
      id="edit-reg-number"
      title="Edit Ticket Number"
      @close="onHide()"
      @cancel="onHide()"
      @ok.prevent="attemptLink()"
      :ok-disabled="!selected || (matchedPerson && !viewed)"
    >
      <form @submit.prevent="searchRegId()">
        <label for="reg-id-input">Ticket Number</label>
        <div class="d-flex align-items-center input-line">
          <b-input-group prepend="#"
            ><b-form-input
              type="text"
              id="reg-id-input"
              v-model="partialRegId"
            ></b-form-input
          ></b-input-group>
          <b-button class="ml-2" variant="primary" size="sm" type="submit"
            >Search</b-button
          >
        </div>
      </form>
      <div class="display-sync-data">
        <h6 v-if="selected">
          {{ REG_ID_FOUND
          }}<span v-if="matchedPerson"
            >, already linked to <strong>{{ matchedPerson }}</strong> in
            Planorama.</span
          ><span v-if="!matchedPerson"
            >, not currently linked to anybody in Planorama.</span
          >
        </h6>
        <b-button
          v-if="matchedPerson"
          variant="link"
          v-b-toggle.sync-data
          class="pl-0"
          >See matched person</b-button
        >
        <b-collapse id="sync-data" :visible="!matchedPerson" @shown="markViewed()">
          <display-sync-data
            :regData="selected"
            class="ml-2"
          ></display-sync-data>
        </b-collapse>
        <div class="text-muted font-italic" v-if="!selected && !searched">
          {{ REG_ID_SEARCH_PLACEHOLDER }}
        </div>
        <div class="text-muted font-italic" v-if="!selected && searched">
          {{ REG_ID_NOT_FOUND }}
        </div>
      </div>
    </edit-modal>
    <plano-modal id="unmatch-match">This will unlink <strong>{{ matchedPerson }}</strong> from ticket number {{ selectedRegNumber }}, and link to the current profile.
      <template #modal-footer="{ok, cancel}">
        <b-button variant="link" @click="cancel()">Cancel</b-button>
        <spinner-button variant="danger" :loading="unlinkLinkLoading" @click="unlinkLink(ok)">Ok</spinner-button>
      </template>
    </plano-modal>
  </div>
</template>

<script>
import DisplaySyncData from "@/registrations/display_sync_data.vue";
import EditModal from "@/components/edit_modal.vue";
import PlanoModal from "@/components/plano_modal.vue";
import SpinnerButton from "@/shared/spinner-button.vue";
import { mapActions } from "vuex";
import {
  GET_REG_BY_ID,
  registrationSyncDatumModel as model,
} from "@/store/registration_sync_datum.store";
import { modelMixinNoProp } from "@/mixins";
import { personSyncDatumMixin } from "@/store/person_sync_datum.mixin";
import {
  REG_ID_SEARCH_PLACEHOLDER,
  REG_ID_FOUND,
  REG_ID_NOT_FOUND,
} from "@/constants/strings";
import { UNLINK_PERSON } from "@/store/person.store";

export default {
  name: "PersonEditRegNumber",
  components: {
    DisplaySyncData,
    EditModal,
    PlanoModal,
    SpinnerButton,
  },
  mixins: [modelMixinNoProp, personSyncDatumMixin],
  props: {
    canUnlink: {
      default: null,
    },
  },
  data: () => ({
    partialRegId: null,
    searched: false,
    viewed: false,
    unlinkLinkLoading: false,
    model,
    REG_ID_SEARCH_PLACEHOLDER,
    REG_ID_FOUND,
    REG_ID_NOT_FOUND,
  }),
  computed: {
    regId() {
      return `#${this.partialRegId}`;
    },
    matchedPerson() {
      return this.selected?.matched_person?.published_name;
    },
    selectedRegNumber() {
      return this.selected?.registration_number;
    }
  },
  methods: {
    ...mapActions({
      getRegById: GET_REG_BY_ID,
      unlinkPerson: UNLINK_PERSON,
    }),
    onHide() {
      this.unselect();
      this.partialRegId = null;
      this.searched = false;
      this.viewed = false;
    },
    markViewed() {
      this.viewed = true;
    },
    attemptLink() {
      if (this.matchedPerson) {
        this.$bvModal.show("unmatch-match");
      } else {
        this.manualMatchSelected().then(() => {
          this.$bvModal.hide("edit-reg-number");
          this.onHide();
        })
      }
    },
    unlinkLink(okMethod) {
      // first unlink person
      console.log("should unlink", this.selected?.matched_person);
      this.unlinkLinkLoading = true;
      this.unlinkPerson({
        person: this.selected.matched_person,
        select: false,
      }).then(() => {
        this.manualMatchSelected().then(() => {
          this.unlinkLinkLoading = false;
          okMethod();
          this.$bvModal.hide("edit-reg-number");
          this.onHide();
        });
      });
    },

    searchRegId() {
      this.getRegById({ id: this.regId }).then(() => {
        this.searched = true;
      });
    },
  },
};
</script>

<style lang="scss" scoped>
form {
  label {
    display: block;
  }
  .input-line {
    width: 60%;
  }
}
.display-sync-data {
  margin-top: 1.5rem;
  min-height: 19rem;
  padding-top: 0.5rem;
  border-top: 1px solid #dee2e6;
}
</style>
