<template>
  <b-form ref='add-room-form'>
    <model-field label="Nazwa" v-model="roomData.name" type="text" stateless></model-field>
    <model-field label="Piętro" v-model="roomData.floor" type="text" stateless></model-field>
    <model-field label="Cel" v-model="roomData.purpose" type="text" stateless></model-field>
    <div class="d-flex justify-content-end" v-if='showButtons'>
      <b-button variant="link" @click="clear">Anuluj</b-button>
      <b-button variant="primary" @click="saveRoom">Zapisz</b-button>
    </div>
  </b-form>
</template>

<script>
import toastMixin from '../shared/toast-mixin';
import settingsMixin from "@/store/settings.mixin";
import { ADMIN_ADD_ROOM_SUCCESS } from '@/constants/strings';
import ModelField from '../shared/model-field';
import PlanoEditor from '../components/plano_editor';

import { mapActions } from 'vuex';
import { NEW_ROOM } from '@/store/room.store';

export default {
  name: "RoomEditor",
  components: {
    ModelField,
    PlanoEditor
  },
  mixins: [
    toastMixin,
      settingsMixin
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
            ADMIN_ADD_ROOM_SUCCESS(obj.title),
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
