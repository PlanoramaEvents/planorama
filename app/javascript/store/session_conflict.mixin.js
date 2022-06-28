import {mapActions } from 'vuex';
import { sessionConflictModel as model} from '@/store/session_conflict.store';
import {GET_CONFLICTS_FOR_SESSION} from '@/store/session_conflict.store';
import {GET_CONFLICTS_WITH_SESSION} from '@/store/session_conflict.store';
import {IGNORE_CONFLICT} from '@/store/session_conflict.store';

import modelMixin from "./model.mixin";

export const sessionConflictMixin = {
  mixins: [modelMixin],
  methods: {
    ...mapActions({
      get_conflicts_for_session: GET_CONFLICTS_FOR_SESSION,
      get_conflicts_with_session: GET_CONFLICTS_WITH_SESSION,
      do_ignore_conflict: IGNORE_CONFLICT
    }),
    get_conflicts({session_id}) {
      return this.get_conflicts_for_session({session_id: session_id});
    },
    get_conflicts_with({session_id}) {
      return this.get_conflicts_with_session({session_id: session_id});
    },
    ignore_conflict({conflict_id, conflict_type}) {
      console.debug("***** IGNORE C")
      return this.do_ignore_conflict({conflict_id: conflict_id, conflict_type: conflict_type});
    }
  }
}

export default sessionConflictMixin;
