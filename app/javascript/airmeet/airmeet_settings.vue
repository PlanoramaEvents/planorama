<template>
  <div class="container-fluid">
    <div class="row">
      <div class="column">
        <h4>Configuration</h4>
        <b-form-group label="Airmeet ID">
          <b-form-input type="text" v-model="config.airmeet_id"></b-form-input>
        </b-form-group>
        <b-form-group label="Airmeet Host Email">
          <b-form-input type="text" v-model="config.airmeet_host"></b-form-input>
        </b-form-group>
        <h4>Rooms</h4>
        <b-table :fields="airmeetRoomFields" :items="airmeetRooms">
          <template #cell(room_host_email)="{ item }">
            <b-input type="text" v-model="item.integrations.airmeet.room_host_email" @blur="save(item)"></b-input>
          </template>
        </b-table>
        <b-form inline @submit.prevent="addAirmeetRoom($event)">
          <b-form-select name="room" :options="nonAirmeetRoomOptions" :value="null"></b-form-select>
          <b-input type="text" name="roomHostEmail" placeholder="Room Host Email"></b-input>
          <b-button type="submit">Add Airmeet Room</b-button>
        </b-form>
      </div>
    </div>
  </div>
</template>

<script>
import { modelMixinNoProp } from '@/mixins'

export default {
  name: "AirmeetSettings",
  mixins: [
    modelMixinNoProp
  ],
  data: () => ({
    config: {
      airmeet_id: null,
      airmeet_host: null,
    },
    airmeetRoomFields: ['name', 'room_host_email'],
    model: 'room'
  }),
  computed: {
    airmeetRooms() {
      return this.collection.filter(r => r.integrations?.airmeet)
    },
    nonAirmeetRoomOptions() {
      return [{text: "Select a room", value: null, disabled: true}, ...this.collection.filter(r => !r.integrations?.airmeet).map(r => ({
        text: r.name,
        value: r.id
      }))]
    },
  },
  methods: {
    addAirmeetRoom($event) {
      const roomId = $event.target.elements.room.value;
      const roomHostEmail = $event.target.elements.roomHostEmail.value;
      const room = this.collection.find(r => r.id === roomId);
      room.integrations ||= {}
      room.integrations.airmeet ||= {}
      room.integrations.airmeet.room_host_email = roomHostEmail;
      this.save(room);
    }
  },
  mounted() {
    this.fetch();
  }
}
</script>

<style>

</style>
