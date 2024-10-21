import {mapState, mapActions } from 'vuex';
import { toastMixin, modelMixin } from "@/mixins";
import { NEW_CONFIGURATION } from "../store/configuration.store";
import { SAVE, DELETE } from "../store/model.store";

import {
  CONFIGURATION_SAVED_SUCCESS,
  CONFIGURATION_SAVED_ERROR
} from '@/constants/strings'

export const configurationMixin = {
  mixins: [modelMixin, toastMixin],
  methods: {
    ...mapActions({ newConfiguration: NEW_CONFIGURATION}),
    createConfiguration(configuration, success_text = CONFIGURATION_SAVED_SUCCESS, error_text = CONFIGURATION_SAVED_ERROR) {
      return this.toastPromise(
        this.newConfiguration({configuration: configuration }), success_text, error_text
      );
    }
  }
}

export default configurationMixin;
