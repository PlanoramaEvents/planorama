<template>
  <div>
      <sidebar-vue v-if="room" model="room">
        <template #header>
          <h3>Room Details</h3>
          <small class="text-muted d-block">Last updated:</small>
          <small class="text-muted d-block"> by <em><strong>{{room.updated_by && room.updated_by.name}}</strong></em></small>
          <small class="text-muted d-block"> on <em><strong>{{new Date(room.updated_at).toLocaleString()}}</strong></em></small>
        </template>
        <template #content v-if="room">
          <b-row>
            <b-col>
              <h2 class="font-weight-light">{{room.name}}</h2>
            </b-col>
          </b-row>
          <b-row>
            <b-col>
              <p><strong>Purpose:</strong> {{room.purpose}}</p>
            </b-col>
          </b-row>
          <div class="float-right d-flex justify-content-end">
            <b-button title="Edit Room" variant="primary" :to="editLink"><b-icon-pencil variant="white"></b-icon-pencil></b-button>
            <b-button title="Duplicate Room" @click="duplicate"><b-icon-files></b-icon-files></b-button>
            <b-button title="Delete Room" v-b-modal.confirmDelete><b-icon-trash></b-icon-trash></b-button>
          </div>
        </template>
      </sidebar-vue>
      <b-modal id="confirmDelete" @ok="destroy" ok-title="Yes" cancel-variant="link" title="Delete room?">
        <p>{{ROOM_CONFIRM_DELETE}}</p>
      </b-modal>
  </div>
</template>

<script>
import toastMixin from '../shared/toast-mixin';
import { VENUES_ADD_ROOM_SUCCESS, ROOM_CONFIRM_DELETE } from '@/constants/strings';
import SidebarVue from '../components/sidebar_vue';
import {mapGetters, mapState, mapActions} from 'vuex';

import { NEW_ROOM, DUPLICATE_ROOM, roomModel as model } from '@/store/room.store';
import {SELECTED} from "@/store/model.store";

export default {
  name: "RoomSidebar",
  components: {
    SidebarVue
  },
  mixins: [
    toastMixin,
    // settingsMixin
  ],
  props: {
    showButtons: {
      default: true,
      type: Boolean
    },
    readOnly: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      roomData: {
        name: '',
        floor: '',
        purpose: '',
      },
      ROOM_CONFIRM_DELETE
    }
  },
  emits: ["saved"],
  computed: {
    ...mapGetters({
      selected: SELECTED
    }),
    room() {
      return this.selected({model});
    },
    editLink() {
      return `/venues/editRoom/${this.room.id}`;
    },
    // room_enums: {
    //   get: function() {
    //     if (this.currentSettings && this.currentSettings.enums) {
    //       return this.currentSettings.enums.Room.target
    //     } else {
    //       return []
    //     }
    //   }
    // }
  },
  methods: {
    ...mapActions({
      newRoomAction: NEW_ROOM,
      duplicateRoom: DUPLICATE_ROOM
    }),
    clear() {
      this.roomData.name = '';
      this.roomData.floor = '';
      this.roomData.purpose = '';
    },
    destroy() {
      alert("OMG! They want to destroy room "+this.room.id);
    },
    duplicate() {
      this.duplicateRoom({item: this.room}).then((newRoom) => {
        this.$router.push(`venues/editRoom/${newRoom.id}`)
      }).catch((error) => this.error_toast(error.message));
    },
    setRoomData(data) {
      //console.log("setRoomData: ", data);
      if(data && data.name) {
        this.roomData.name = data.name;
        this.roomData.floor = data['floor'];
        this.roomData.purpose = data.purpose;
      }
    },
    saveRoom() {
      let res = this.newRoomAction(this.roomData);
      res.then(
        (obj) => {
          this.$bvToast.toast(
            VENUES_ADD_ROOM_SUCCESS(obj.name),
            {
              variant: 'success',
              title: 'Room Created'
            }
          )
          this.clear()
          this.$emit("saved");
        }
      ).catch(
        (err) => {
          this.$bvToast.toast(
            err.response.data.errors[0].title,
            {
              variant: 'danger',
              title: err.response.data.errors[0].title
            }
          )
        }
      );
    }
  }
}
</script>

<style>

</style>
