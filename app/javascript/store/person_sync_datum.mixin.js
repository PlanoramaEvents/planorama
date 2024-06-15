import { toastMixin } from "@/mixins";
import { SELECTED } from "./model.store"
import { personModel } from "./person.store"
import { MATCH } from "./person_sync_datum.store";
import { registrationSyncDatumModel } from "./registration_sync_datum.store"
import { mapActions} from "vuex";

export const personSyncDatumMixin = {
  mixins: [
    toastMixin
  ],
  computed: {
    selectedPerson() {
      return this.$store.getters[SELECTED]({model: personModel})
    },
    selectedRegDatum() {
      return this.$store.getters[SELECTED]({model: registrationSyncDatumModel})
    }
  },
  methods: {
    ...mapActions({
      matchPersonAndReg: MATCH,
    }),
    manualMatch(regId, personId) {
      return this.toastPromise(this.matchPersonAndReg({
        regId,
        personId,
        regMatch: 'manual'
      }), "Person successfully linked to Registration")
    },
    manualMatchSelected() {
      return this.manualMatch(this.selectedRegDatum.reg_id, this.selectedPerson.id);
    }
  }
}
