import { toastMixin } from "@/mixins";
import { SELECTED } from "./model.store"
import { personModel } from "./person.store"
import { MATCH, DISMISS } from "./person_sync_datum.store";
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
      dismiss: DISMISS,
    }),
    manualMatch(regId, personId) {
      return this.toastPromise(this.matchPersonAndReg({
        regId,
        personId,
        regMatch: 'manual',
        reload: true
      }), "Person successfully linked to Registration")
    },
    manualMatchSelected() {
      return this.manualMatch(this.selectedRegDatum.reg_id, this.selectedPerson.id);
    },
    assistedMatch(regId, personId) {
      return this.toastPromise(this.matchPersonAndReg({
        regId,
        personId,
        regMatch: 'assisted'
      }), "Person successfully linked to Registration")
    },
    dismissMatch(regId, personId) {
      return this.toastPromise(this.dismiss({
        regId, personId
      }), "Potential match successfully dismissed")
    }
  }
}
