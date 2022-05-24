<template>
  <sidebar-vue v-if="room" model="room">
    <template #header>
      <h3>Room Details</h3>
      <small class="text-muted d-block">Last updated:</small>
      <small class="text-muted d-block"> by <em><strong>{{room.updated_by && room.updated_by.name}}</strong></em></small>
      <small class="text-muted d-block"> on <em><strong>{{new Date(room.updated_at).toLocaleString()}}</strong></em></small>
    </template>
  </sidebar-vue>
</template>

<script>
import toastMixin from '../shared/toast-mixin';
import { VENUES_ADD_ROOM_SUCCESS } from '@/constants/strings';
import SidebarVue from '../components/sidebar_vue';
import {mapGetters, mapState, mapActions} from 'vuex';

import { NEW_ROOM, roomModel as model } from '@/store/room.store';
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
    }
  },
  emits: ["saved"],
  computed: {
    ...mapGetters({
      selected: SELECTED
    }),
    room() {
      alert("in room_sidebar.room(): "+ this.selected({model}));
      return this.selected({model});
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
    ...mapActions({newRoomAction: NEW_ROOM}),
    clear() {
      this.roomData.name = '';
      this.roomData.floor = '';
      this.roomData.purpose = '';
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
