<template>
  <div>
    <edit-modal
      id="edit-reg-number"
      title="Edit Registration ID"
      @hidden="onHide()"
      @ok="manualMatchSelected()"
      :ok-disabled="!selected"
    >
      <form @submit.prevent="searchRegId()">
        <label for="reg-id-input">Registration ID</label>
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
        <h6 v-if="selected">{{ REG_ID_FOUND }}<span 
          v-if="matchedPerson">, already linked to <strong>{{ matchedPerson }}</strong> in Planorama.</span><span
           v-if="!matchedPerson">, not currently linked to anybody in Planorama.</span>
        </h6>
        <display-sync-data :regData="selected" class="ml-2"></display-sync-data>
        <div class="text-muted font-italic" v-if="!selected && !searched">
          {{ REG_ID_SEARCH_PLACEHOLDER }}
        </div>
        <div class="text-muted font-italic" v-if="!selected && searched">
          {{ REG_ID_NOT_FOUND }}
        </div>
      </div>
      <!-- <template #modal-footer="{cancel, ok, close}">
      <div class="d-flex w-100 justify-content-between">
        <b-button variant="danger" @click="close" v-b-modal.unlink-confirmation :disabled="!canUnlink">{{REG_ID_UNLINK_BUTTON}}</b-button>
        <div>
          <b-button variant="link" @click="cancel">Cancel</b-button>
          <b-button variant="primary" @click="ok" :disabled="!selected">Save</b-button>
        </div>
      </div>
    </template> -->
    </edit-modal>
  </div>
</template>

<script>
import DisplaySyncData from "@/registrations/display_sync_data.vue";
import EditModal from "@/components/edit_modal.vue";
import PlanoModal from "@/components/plano_modal.vue";
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

export default {
  name: "PersonEditRegNumber",
  components: {
    DisplaySyncData,
    EditModal,
    PlanoModal,
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
    }
  },
  methods: {
    ...mapActions({
      getRegById: GET_REG_BY_ID,
    }),
    onHide() {
      this.unselect();
      this.partialRegId = null;
      this.searched = false;
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
  min-height: 15rem;
  padding-top: 0.5rem;
  border-top: 1px solid #dee2e6;
}
</style>
