<template>
  <div class="container-fluid">
    <div class="row">
      <div class="column">
        <h4 class="mt-3">Configuration</h4>
        <h4 class="mt-5">Room Zoom Setup</h4>
        <b-form inline @submit.prevent="addZoomRoom($event)" class="mb-5 mt-3">
          <b-form-select name="room" :options="nonZoomRoomOptions" :value="null"></b-form-select>
          <b-form-select name="meeting_type" :options="meetingTypeOptions" :value="null" ></b-form-select>
          <b-form-select name="virtual_room" :options="virtualRoomOptions" :value="false" ></b-form-select>
          <b-input type="email" name="alternate_host" placeholder="xx@yy.com"></b-input>
          <b-button type="submit" :disabled="!zoom_enabled">Add Zoom Room</b-button>
        </b-form>
        <div class="border">
          <b-table :fields="roomFields" :items="zoomRooms" sticky-header class="mb-0">
            <template #cell(meeting_type)="{ item }">
              <b-form-select name="meeting_type" :options="meetingTypeOptions" v-model="item.integrations.zoom.meeting_type" @change="save(item)"></b-form-select>
            </template>
            <template #cell(virtual_room)="{ item }">
              <b-form-select name="meeting_type" :options="virtualRoomOptions" v-model="item.integrations.zoom.virtual_room" @change="save(item)"></b-form-select>
            </template>
            <template #cell(alternate_host)="{ item }">
              <b-input type="email" v-model="item.integrations.zoom.alternate_host" @blur="save(item)"></b-input>
            </template>
          </b-table>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { modelMixinNoProp } from '@/mixins'
import { zoomMixin } from '@/integrations/zoom.mixin'

export default {
  name: "RoomZoomIntegrations",
  mixins: [zoomMixin, modelMixinNoProp],
  data: () => ({
    roomFields: ['name', 'meeting_type', 'virtual_room', 'alternate_host'],
    meetingTypeOptions: [
      {text: "Select Type", value: null, disabled: false},
      {text: "webinar", value: 'webinar', disabled: false},
      {text: "meeting", value: 'meeting', disabled: false},
      {text: "discord", value: 'discord', disabled: false},
    ],
    virtualRoomOptions: [
      {text: "No", value: false, disabled: false},
      {text: "Yes", value: true, disabled: false},
    ],
    model: 'room'
  }),
  computed: {
    zoomRooms() {
      return this.collection.filter(r => r.integrations?.zoom).sort((a, b) => a.sort_order > b.sort_order)
    },
    nonZoomRoomOptions() {
      return [{text: "Select a room", value: null, disabled: true}, ...this.collection.filter(r => !r.integrations?.zoom).sort((a, b) => a.sort_order > b.sort_order).map(r => ({
        text: r.name,
        value: r.id
      }))]
    },
  },
  methods: {
    addZoomRoom($event) {
      const roomId = $event.target.elements.room.value;
      const meeting_type = $event.target.elements.meeting_type.value;
      const virtual_room = $event.target.elements.virtual_room.value;
      const alternate_host = $event.target.elements.alternate_host.value;
      const room = this.collection.find(r => r.id === roomId);
      room.integrations ||= {}
      room.integrations.zoom ||= {}
      room.integrations.zoom.meeting_type = meeting_type;
      room.integrations.zoom.virtual_room = virtual_room;
      room.integrations.zoom.alternate_host = alternate_host;
      this.save(room);
    },
  },
  mounted() {
    this.fetch();
  }
}
</script>
