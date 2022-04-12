import {mapActions } from 'vuex';
import { availabilityModel as model} from '@/store/availability.store';
import {NEW_AVAILABILITY, UPDATE_AVAILABILITY, GET_AVAILABILITY} from '@/store/availability.store';

import modelMixin from "./model.mixin";

import {
  UPDATE_AVAILABILITY_SUCCESS,
  UPDATE_AVAILABILITY_ERROR
} from '../constants/strings'

export const availabilityMixin = {
  mixins: [modelMixin],
  methods: {
    ...mapActions({
      new_availability: NEW_AVAILABILITY, // TODO: check if we need
      update_availability_in_store: UPDATE_AVAILABILITY,
      get_availability: GET_AVAILABILITY
    }),
    update_availability({person, params}, success_text = UPDATE_AVAILABILITY_SUCCESS, error_text = UPDATE_AVAILABILITY_ERROR) {
      this.clear()
      // Send all datetimes to backend as UTC
      let utc_params = params.map((slot) => { return {end: slot.end.toUTC(), start: slot.start.toUTC()} })

      return this.toastPromise(
        this.update_availability_in_store({person: person, params: utc_params}),
        success_text,
        error_text
      );

    }
  }
}

export default availabilityMixin;
