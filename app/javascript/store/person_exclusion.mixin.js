import {mapActions } from 'vuex';
import { personExclusionModel as model} from '@/store/person_exclusion.store';
import {UPDATE_PERSON_EXCLUSIONS, GET_PERSON_EXCLUSIONS} from '@/store/availability.store';

import modelMixin from "./model.mixin";

export const availabilityMixin = {
  mixins: [modelMixin],
  methods: {
    ...mapActions({
      update_exclusions_in_store: UPDATE_PERSON_EXCLUSIONS,
      get_exclusions: GET_PERSON_EXCLUSIONS
    }),
    update_exclusions({person, params}) {
      this.clear()
      // Send all datetimes to backend as UTC
      // let utc_params = params.map((slot) => { return {end: slot.end.toUTC(), start: slot.start.toUTC()} })
      // return this.update_exclusions_in_store({person: person, params: utc_params})
    }
  }
}

export default availabilityMixin;
