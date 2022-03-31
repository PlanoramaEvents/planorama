import {mapActions } from 'vuex';
import { personExclusionModel as model} from '@/store/person_exclusion.store';
import {UPDATE_PERSON_EXCLUSIONS, GET_PERSON_EXCLUSIONS} from '@/store/person_exclusion.store';

import modelMixin from "./model.mixin";

export const availabilityMixin = {
  mixins: [modelMixin],
  methods: {
    ...mapActions({
      update_person_exclusions: UPDATE_PERSON_EXCLUSIONS,
      get_exclusions: GET_PERSON_EXCLUSIONS
    }),
    update_exclusions({person, params}) {
      this.clear()
      return this.update_person_exclusions({person: person, params: params})
    }
  }
}

export default availabilityMixin;
