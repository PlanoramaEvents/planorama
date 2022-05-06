<template>
  <b-form ref='add-roomset-form'>
    <model-field label="Name" v-model="roomsetData.name" type="text" stateless></model-field>
    <model-field label="Description" v-model="roomsetData.description" type="text" stateless></model-field>
    <div class="d-flex justify-content-end" v-if='showButtons'>
      <b-button variant="link" @click="clear">Cancel</b-button>
      <b-button variant="primary" @click="saveRoomset">Save</b-button>
    </div>
  </b-form>
</template>

<script>
import toastMixin from '../shared/toast-mixin';
import settingsMixin from "@/store/settings.mixin";
import { VENUES_ADD_ROOMSET_SUCCESS } from '@/constants/strings';
import ModelField from '../shared/model-field';

import { mapActions } from 'vuex';
import { NEW_ROOMSET } from '@/store/roomset.store';

export default {
  name: "RoomsetEditor",
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
      roomsetData: {
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
    ...mapActions({newRoomsetAction: NEW_ROOMSET}),
    clear() {
      this.roomsetData.name = '';
      this.roomsetData.description = '';
    },
    setRoomsetData(data) {
      //console.log("setRoomsetData: ", data);
      if(data && data.name && data.description) {
        this.roomsetData.name = data.name;
        this.roomsetData.description = data.description;
      }
    },
    saveRoomset() {
      let res = this.newRoomsetAction(this.roomsetData);
      res.then(
        (obj) => {
          this.$bvToast.toast(
            VENUES_ADD_ROOMSET_SUCCESS(obj.title),
            {
              variant: 'success',
              title: 'Roomset Created'
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
