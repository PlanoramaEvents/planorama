import {mapGetters, mapState, mapActions} from 'vuex';
import toastMixin from '../shared/toast-mixin';
import { SAVE, SELECT, SELECTED, FETCH_SELECTED, DELETE, UNSELECT, PATCH_FIELDS } from '../store/model.store';
import { SESSION_SAVE_SUCCESS_DELETE, SESSION_SAVE_ERROR_DELETE, SESSION_SAVE_SUCCESS, SESSION_SAVE_ERROR } from '../constants/strings'
import { sessionModel as model } from '../store/session.store';

export const sessionMixin = {
  mixins: [toastMixin],
  computed: {
    ...mapGetters({
      selected: SELECTED
    }),
    session() {
      return this.selected({model});
    }
  },
  methods: {
    saveSession(newSession, selected = true, room_ids = null, success_text = SESSION_SAVE_SUCCESS, error_text = SESSION_SAVE_ERROR) {
      if (!newSession) {
        newSession = this.session;
      }
      if (room_ids) {
        let existingRooms = Object.values(newSession.assigned_rooms)
        let newRooms = room_ids
        let roomsForSaving = []

        for (let room of newRooms) {
          if (room) roomsForSaving.push({id: room})
        }
        for (let room of existingRooms) {
          if (!newRooms.includes(room.id)) {
            roomsForSaving.push({id: room.id, _destroy: 1})
          }
        }
        newSession.assigned_rooms_attributes = roomsForSaving
      }
      return this.toastPromise(this.$store.dispatch(SAVE, {model, selected: selected, item: newSession}), success_text, error_text)
    },
    selectSession(itemOrId) {
      this.$store.commit(SELECT, {model, itemOrId});
    },
    unselectSession() {
      this.$store.commit(UNSELECT, {model})
    },
    fetchSelectedSession() {
      return this.$store.dispatch(FETCH_SELECTED, {model});
    },
    deleteSession(itemOrId, success_text = SESSION_SAVE_SUCCESS_DELETE, error_text = SESSION_SAVE_ERROR_DELETE) {
      if (!itemOrId) {
        itemOrId = this.session;
      }
      return this.toastPromise(this.$store.dispatch(DELETE, {model, itemOrId}), success_text, error_text);
    }
  }
}

export default sessionMixin;
