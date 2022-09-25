<template>
  <div class="container-fluid">
    <div class="row">
      <div class="column">
        <h4 class="mt-3">Configuration</h4>
        <b-form-group label-cols="auto" label="Enable Airmeet" class="configuration enable">
          <b-form-checkbox switch v-model="airmeet_enabled" @change="patchAirmeetConfig()"></b-form-checkbox>
        </b-form-group>
        <b-form-group label="Airmeet ID">
          <b-form-input type="text" v-model="airmeet_id" @blur="patchAirmeetConfig()"></b-form-input>
        </b-form-group>
        <b-form-group label="Airmeet Host Email">
          <b-form-input type="text" v-model="airmeet_host" @blur="patchAirmeetConfig()"></b-form-input>
        </b-form-group>
        <h4 class="mt-5">Room Hosts Setup</h4>
        <b-form inline @submit.prevent="addAirmeetRoom($event)" class="mb-5 mt-3">
          <b-form-select name="room" :options="nonAirmeetRoomOptions" :value="null"></b-form-select>
          <b-input type="text" name="roomHostEmail" placeholder="Room Host Email"></b-input>
          <b-button type="submit">Add Airmeet Room</b-button>
        </b-form>
        <div class="border">
        <b-table :fields="airmeetRoomFields" :items="airmeetRooms" sticky-header class="mb-0">
          <template #cell(room_host_email)="{ item }">
            <b-input type="text" v-model="item.integrations.airmeet.room_host_email" @blur="save(item)"></b-input>
          </template>
        </b-table>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { modelMixinNoProp } from '@/mixins'
import { FETCH_AIRMEET_INTEGRATION, integrationModel, SET_AIRMEET_INTEGRATION } from '@/store/integration.store'
import { PATCH_FIELDS, SAVE } from '@/store/model.store'
import { mapState, mapActions, mapMutations } from 'vuex';
import toastMixin from '@/shared/toast-mixin';

export default {
  name: "AirmeetSettings",
  mixins: [
    modelMixinNoProp,
    toastMixin
  ],
  data: () => ({
    airmeetRoomFields: ['name', 'room_host_email'],
    model: 'room'
  }),
  computed: {
    ...mapState(['airmeet']),
    airmeetRooms() {
      return this.collection.filter(r => r.integrations?.airmeet)
    },
    nonAirmeetRoomOptions() {
      return [{text: "Select a room", value: null, disabled: true}, ...this.collection.filter(r => !r.integrations?.airmeet).map(r => ({
        text: r.name,
        value: r.id
      }))]
    },
    airmeet_id: {
      get() {
        return this.airmeet?.config?.airmeet_id
      }, 
      set(val) {
        if(this.airmeet?.config) {
          this.airmeet.config.airmeet_id = val;
        }
      }
    },
    airmeet_host: {
      get() {
        return this.airmeet?.config?.airmeet_host
      }, 
      set(val) {
        if(this.airmeet?.config) {
          this.airmeet.config.airmeet_host = val;
        }
      }
    },
    airmeet_enabled: {
      get() {
        return this.airmeet?.config?.enabled
      },
      set(val) {
        if(this.airmeet?.config) {
          this.airmeet.config.enabled = val;
        }
      }
    }
  },
  methods: {
    ...mapMutations({
      setAirmeetInfo: SET_AIRMEET_INTEGRATION,
    }),
    ...mapActions({
      fetchAirmeetInfo: FETCH_AIRMEET_INTEGRATION,
      patchModel: PATCH_FIELDS
    }),
    addAirmeetRoom($event) {
      const roomId = $event.target.elements.room.value;
      const roomHostEmail = $event.target.elements.roomHostEmail.value;
      const room = this.collection.find(r => r.id === roomId);
      room.integrations ||= {}
      room.integrations.airmeet ||= {}
      room.integrations.airmeet.room_host_email = roomHostEmail;
      this.save(room);
    },
    patchAirmeetConfig() {
      this.toastPromise(new Promise((res, rej) => {
        this.patchModel({model: integrationModel, item: this.airmeet, fields: ['config'], selected: false}).then((data) => {
          this.setAirmeetInfo(data);
          res(data);
        }).catch(rej);
      }), "Airmeet integration successfully updated.")
    }
  },
  mounted() {
    this.fetch();
    this.fetchAirmeetInfo();
  }
}
</script>

<style lang="scss">
.configuration.enable .form-row {
  align-items: center;
}
</style>
