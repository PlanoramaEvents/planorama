<template>
  <div class="container-fluid">
    <div class="row">
      <div class="column">
        The only integration we support right now is airmeet.

        <b-table :fields="airmeetRoomFields" :items="airmeetRooms">
          <template #cell(room_host_email)="{ item }">
            <b-input type="text" v-model="item.integrations.airmeet.room_host_email"></b-input>
          </template>
        </b-table>
        <b-form inline @submit="addAirmeetRoom($event)">
          <b-select name="room" :options="nonAirmeetRoomOptions"></b-select>
          <b-input type="text" name="roooHostEmail"></b-input>
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
    airmeetRoomFields: ['name', 'room_host_email' ],
    model: 'room'
  }),
  computed: {
    airmeetRooms() {
      return this.collection.filter(r => r.integrations?.airmeet?.room_host_email)
    },
    nonAirmeetRoomOptions() {
      return this.collection.filter(r => !r.integrations?.airmeet?.room_host_email).map(r => ({
        text: r.name,
        value: r
      }))
    },
  },
  methods: {
    addAirmeetRoom($event) {
      $event.preventDefault();
      console.log($event)
      let room, roomHostEmail;
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
