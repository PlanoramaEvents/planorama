import {mapGetters, mapActions, mapState } from 'vuex';
import { GET_SEARCH_STATE, SET_SEARCH_STATE }  from "@/store/search_state.store";

export const searchStateMixin = {
  computed: {
    ...mapState({
      currentSearchSettings: 'currentSearchSettings'
    })
  },
  methods: {
    ...mapGetters({
      getSearchState: GET_SEARCH_STATE
    }),
    ...mapActions({
      setSearchState: SET_SEARCH_STATE
    })
  }
}

export default searchStateMixin;
