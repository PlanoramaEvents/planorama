import { mapGetters, mapActions } from "vuex";
import { FETCH_REG_SYNC_STATS, REG_SYNC_STATS } from "./registration_sync_datum.store";
import { DateTime } from "luxon";

export const registrationSyncStatsMixin = {
  computed: {
    ...mapGetters({
      stats: REG_SYNC_STATS
    }),
    lastSync() {
      return DateTime.fromISO(this.stats?.updated_at).toFormat('D, t ZZZZ');
    }
  },
  methods: {
    ...mapActions({
      fetchStats: FETCH_REG_SYNC_STATS
    })
  }
}
