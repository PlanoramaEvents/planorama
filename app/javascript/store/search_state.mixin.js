import {mapGetters, mapActions, mapState, mapMutations } from 'vuex';
import { GET_SEARCH_STATE, SET_SEARCH_STATE, SET_TIME_ZONE }  from "@/store/search_state.store";

export const searchStateMixin = {
  computed: {
    ...mapState(['currentSearchSettings', 'availabilityTimeZone']),
    calTimeZone: {
      get() {
        return this.availabilityTimeZone;
      },
      set(value) {
        this.setAvailabilityTimeZone(value);
      }
    }
  },
  methods: {
    ...mapGetters({
      getSearchState: GET_SEARCH_STATE
    }),
    ...mapActions({
      setSearchState: SET_SEARCH_STATE
    }),
    ...mapMutations({
      setAvailabilityTimeZone: SET_TIME_ZONE
    })
  }
}

export default searchStateMixin;
