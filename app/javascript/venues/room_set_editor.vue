<template>
  <b-form ref='add-room-set-form'>
    <model-field label="Name" v-model="roomSetData.name" type="text" stateless></model-field>
    <model-field label="Description" v-model="roomSetData.description" type="text" stateless></model-field>
    <div class="d-flex justify-content-end" v-if='showButtons'>
      <b-button variant="link" @click="clear">Cancel</b-button>
      <b-button variant="primary" @click="saveRoomSet">Save</b-button>
    </div>
  </b-form>
</template>

<script>
import toastMixin from '@/mixins/toast-mixin';
import settingsMixin from "@/store/settings.mixin";
import { VENUES_ADD_ROOMSET_SUCCESS } from '@/constants/strings';
import ModelField from '@/components/model-field';

import { mapActions } from 'vuex';
import { NEW_ROOMSET } from '@/store/room_set.store';

export default {
  name: "RoomSetEditor",
  components: {
    ModelField,
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
      roomSetData: {
        name: '',
        description: '',
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
    ...mapActions({newRoomSetAction: NEW_ROOMSET}),
    clear() {
      this.roomSetData.name = '';
      this.roomSetData.description = '';
    },
    setRoomSetData(data) {
      //console.log("setRoomsetData: ", data);
      if(data && data.name && data.description) {
        this.roomsetData.name = data.name;
        this.roomsetData.description = data.description;
      }
    },
    saveRoomSet() {
      let res = this.newRoomSetAction(this.roomSetData);
      res.then(
        (obj) => {
          this.$bvToast.toast(
            VENUES_ADD_ROOMSET_SUCCESS(obj.title),
            {
              variant: 'success',
              title: 'Room Set Created'
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
