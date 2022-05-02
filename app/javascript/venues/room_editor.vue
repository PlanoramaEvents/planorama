<template>
  <b-form ref='add-room-form'>
    <model-field label="Name" v-model="roomData.title" type="text" stateless></model-field>
    <label>Body</label>
    <plano-editor
        v-model="roomData.terms"
        type='classic'
        :disabled="readOnly"
    ></plano-editor>
    <label>Room Type:</label>
    <select v-model="roomData.room_type" style="padding-right: 15px">
      <option v-for="type in currentSettings.room_types" :selected="type === selected_room_type">{{type}}</option>
    </select>
    <label>Target:</label>
    <select v-model="roomData.target">
      <option v-for="role in room_enums" :selected="role === selected_target">{{role}}</option>
    </select>
    <div class="d-flex justify-content-end" v-if='showButtons'>
      <b-button variant="link" @click="clear">Cancel</b-button>
      <b-button variant="primary" @click="saveRoom">Save</b-button>
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
        title: '',
        terms: '',
        room_type: '',
        target: ''
      },
      selected_room_type: 'Terms and Conditions',
      selected_target: 'none'
    }
  },
  emits: ["saved"],
  computed: {
    room_enums: {
      get: function() {
        if (this.currentSettings && this.currentSettings.enums) {
          return this.currentSettings.enums.Room.target
        } else {
          return []
        }
      }
    }
  },
  methods: {
    ...mapActions({newRoomAction: NEW_ROOM}),
    clear() {
      this.roomData.title = '';
      this.roomData.terms = '';
      this.roomData.room_type = '';
      this.roomData.target = '';
      this.selected_room_type = 'Terms and Conditions';
      this.selected_target = 'none';
    },
    setRoomData(data) {
      //console.log("setRoomData: ", data);
      if(data && data.title && data.terms && data.room_type && data.target) {
        this.roomData.title = data.title;
        this.roomData.terms = data.terms;
        this.selected_room_type = this.roomData.room_type = data.room_type;
        this.selected_target = this.roomData.target = data.target;
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
