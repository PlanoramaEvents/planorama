import { FETCH_AIRMEET_INTEGRATION } from "@/store/integration.store";
import { mapActions, mapGetters, mapState } from "vuex";

export const airmeetMixin = {
  methods:{
    ...mapActions({
      fetchAirmeetInfo: FETCH_AIRMEET_INTEGRATION
    }),
    fetchAirmeetInfoIfMissing() {
      if (!this.airmeet || !Object.keys(this.airmeet).length) {
        this.fetchAirmeetInfo();
      }
    }
  },
  computed: {
    ...mapGetters(['airmeetEnabled']),
    ...mapState(['airmeet']),
  },
  mounted() {
    this.fetchAirmeetInfoIfMissing();
  }
}
