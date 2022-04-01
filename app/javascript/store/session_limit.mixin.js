import {mapActions } from 'vuex';
import { sessionLimitModel as model} from '@/store/session_limit.store';
import {NEW_SESSION_LIMIT, GET_SESSION_LIMITS} from '@/store/session_limit.store';

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
      get_session_limits: GET_SESSION_LIMITS
    }),
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
