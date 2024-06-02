<template>
    <edit-modal id="edit-reg-number" title="Edit Registration ID" :ok-disabled="!selected" @hidden="onHide()" @ok="manualMatchSelected()">
    <form @submit.prevent="searchRegId()">
      <label for="reg-id-input">Registration ID</label>
      <div class="d-flex align-items-center input-line">
      <b-input-group prepend="#"><b-form-input type="text" id="reg-id-input" v-model="partialRegId"></b-form-input></b-input-group>
      <b-button class="ml-2" variant="primary" size="sm" type="submit">Search</b-button>
      </div>
    </form>
    <div class="display-sync-data">
      <h6 v-if="selected">Found a match in the registration database</h6>
      <display-sync-data :regData="selected" class="ml-2"></display-sync-data>
      <div class="text-muted font-italic" v-if="!selected && !searched">Search for a registration ID.</div>
      <div class="text-muted font-italic" v-if="!selected && searched">No results found. Please check your input.</div>
    </div>
  </edit-modal>
</template>

<script>
import DisplaySyncData from '@/registrations/display_sync_data.vue';
import EditModal from '@/components/edit_modal.vue';
import { mapActions} from "vuex";
import { GET_REG_BY_ID, registrationSyncDatumModel as model } from "@/store/registration_sync_datum.store";
import { modelMixinNoProp } from '@/mixins';
import { personSyncDatumMixin } from '@/store/person_sync_datum.mixin';

export default {
  name: "PersonEditRegNumber",
  components: {
    DisplaySyncData,
    EditModal,
  },
  mixins: [
    modelMixinNoProp,
    personSyncDatumMixin,
  ],
  data: () => ({
    partialRegId: null,
    searched: false,
    model,
  }),
  computed: {
    regId() {
      return `#${this.partialRegId}`
    }
  },
  methods: {
    ...mapActions({
      getRegById: GET_REG_BY_ID
    }),
    onHide() {
      this.unselect();
      this.partialRegId = null;
      this.searched = false;
    },
    searchRegId() {
      console.log('member number is', this.regId);
      this.getRegById({id: this.regId}).then(() => {
        this.searched = true;
      })
      
      // for testing, remove me
      /*if(this.regId == "#123") {
        this.regData = {
    "id": "548cd721-5b5c-4b7a-a9e1-966523493beb",
    "lock_version": 0,
    "created_at": "2024-05-20T01:44:14.130Z",
    "updated_at": "2024-05-20T01:44:14.130Z",
    "reg_id": "49",
    "registration_number": "#123",
    "name": "Chris Baker",
    "email": "fangorn73@hotmail.com",
    "preferred_name": "Chris Baker",
    "alternative_email": null,
    "badge_name": null,
    "raw_info": {
        "id": 49,
        "badge": "Fangorn",
        "email": "fangorn73@hotmail.com",
        "product": "Full Attending Adult",
        "location": "England",
        "full_name": "Chris Baker",
        "date_added": "2022-08-26T12:25:18.000000Z",
        "badge_title": "Glasgow 2024 Guest of Honour",
        "wsfs_status": null,
        "date_updated": "2022-08-26T15:58:37.000000Z",
        "ticket_number": "#0001",
        "preferred_name": "Chris Baker",
        "attending_status": "In Person",
        "alternative_email": null,
        "product_list_name": "Full Adult",
        "participant_activities": []
    }
}
      } else {
        this.regData = null;
      }*/
    }
  }
}
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

