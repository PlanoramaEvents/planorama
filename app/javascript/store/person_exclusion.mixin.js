import {mapActions } from 'vuex';
import { personExclusionModel as model} from '@/store/person_exclusion.store';
import {UPDATE_PERSON_EXCLUSIONS, GET_PERSON_EXCLUSIONS} from '@/store/person_exclusion.store';

import {
  UPDATE_PERSON_EXCLUSION_SUCCESS,
  UPDATE_PERSON_EXCLUSION_ERROR,
  GET_PERSON_EXCLUSION_SUCCESS,
  GET_PERSON_EXCLUSION_ERROR
} from '../constants/strings'

import modelMixin from "./model.mixin";

export const availabilityMixin = {
  mixins: [modelMixin],
  methods: {
    ...mapActions({
      update_person_exclusions: UPDATE_PERSON_EXCLUSIONS,
      get_person_exclusions: GET_PERSON_EXCLUSIONS
    }),
    get_exclusions({person}) {
      this.clear()
      return this.get_person_exclusions({person: person});
    },
    update_exclusions({person, params}, success_text = UPDATE_PERSON_EXCLUSION_SUCCESS, error_text = UPDATE_PERSON_EXCLUSION_ERROR) {
      this.clear()
      return this.toastPromise(
        this.update_person_exclusions({person: person, params: params}),
        success_text,
        error_text
      );
    }
  }
}

export default availabilityMixin;
