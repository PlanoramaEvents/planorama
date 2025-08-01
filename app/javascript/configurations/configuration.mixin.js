import { mapActions } from 'vuex';
import { toastMixin, modelMixin } from "@/mixins";
import { PATCH_FIELDS } from '@/store/model.store';
import { NEW_CONFIGURATION, configurationModel } from '@/store/configuration.store';

import {
  CONFIGURATION_SAVED_SUCCESS,
  CONFIGURATION_SAVED_ERROR
} from '@/constants/strings'

export const configurationMixin = {
  mixins: [modelMixin, toastMixin],
  methods: {
    ...mapActions({ 
      newConfiguration: NEW_CONFIGURATION,
      patchModel: PATCH_FIELDS
    }),
    createConfiguration(configuration, success_text = CONFIGURATION_SAVED_SUCCESS, error_text = CONFIGURATION_SAVED_ERROR) {
      return this.toastPromise(
        this.newConfiguration({configuration: configuration }), success_text, error_text
      );
    },
    patchConfiguration(configuration, fields) {
      return this.toastPromise(new Promise((res, rej) => {
        this.patchModel({model: configurationModel, item: configuration, fields: fields, selected: false}).then((data) => {
          res(data);
        }).catch(rej);
      }), CONFIGURATION_SAVED_SUCCESS)
    },
  }
}

export default configurationMixin;
