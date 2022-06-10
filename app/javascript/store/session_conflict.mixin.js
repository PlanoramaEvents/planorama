import {mapActions } from 'vuex';
import { sessionConflictModel as model} from '@/store/session_conflict.store';
import {GET_CONFLICTS_FOR_SESSION} from '@/store/session_conflict.store';

import modelMixin from "./model.mixin";

export const sessionConflictMixin = {
  mixins: [modelMixin],
  methods: {
    ...mapActions({
      get_conflicts_for_session: GET_CONFLICTS_FOR_SESSION
    }),
    get_conflicts({session_id}) {
      this.clear()
      return this.get_conflicts_for_session({session_id: session_id});
    }
  }
}

export default sessionConflictMixin;
