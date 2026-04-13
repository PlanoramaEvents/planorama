import {mapActions } from 'vuex';
import { sessionLimitModel } from '@/store/session_limit.store';
import {NEW_SESSION_LIMIT, GET_SESSION_LIMITS} from '@/store/session_limit.store';
import { PATCH_FIELDS } from '@/store/model.store';
import { SESSION_LIMIT_SAVE_SUCCESS } from '@/constants/strings';

import modelMixin from "./model.mixin";

import {
  CREATE_SESSION_LIMIT_SUCCESS,
  CREATE_SESSION_LIMIT_ERROR
} from '../constants/strings'

export const sessionLimitMixin = {
  mixins: [modelMixin],
  methods: {
    ...mapActions({
      new_session_limit: NEW_SESSION_LIMIT,
      get_session_limits: GET_SESSION_LIMITS,
      patchModel: PATCH_FIELDS
    }),
    patchSessionLimit(limit, fields) {
      return this.toastPromise(new Promise((res, rej) => {
        this.patchModel({model: sessionLimitModel, item: limit, fields: fields, selected: false}).then((data) => {
          res(data);
        }).catch(rej);
      }), SESSION_LIMIT_SAVE_SUCCESS)
    },
    create_session_limit(candidate, success_text = CREATE_SESSION_LIMIT_SUCCESS, error_text = CREATE_SESSION_LIMIT_ERROR) {
      return this.toastPromise(
        this.new_session_limit({limit: candidate}),
        success_text,
        error_text
      );
    }
  }
}

export default sessionLimitMixin;
