<template>
  <div class="scrollable">
    <b-tabs @input="input" class="mt-2">
      <b-tab title="Rooms">
        <RoomsManager model="room" ref="rooms-manager"></RoomsManager>
      </b-tab>
      <b-tab title="Venues">
        <VenuesManager model="venue" ref="venues-manager"></VenuesManager>
      </b-tab>
      <b-tab title="Room Setups">
        <RoomSetsManager model="roomset" ref="room-sets-manager"></RoomSetsManager>
      </b-tab>
    </b-tabs>
  </div>
</template>

<script>
import RoomsManager from './rooms_manager.vue';
import VenuesManager from './venues_manager.vue';
import RoomSetsManager from './room_sets_manager.vue';

export default {
  name: "VenueManager",
  components: {RoomsManager, VenuesManager, RoomSetsManager},
  data() {
    return {
      activated: false
    }
  },
  methods: {
    input() {
      if(!this.activated) {
        this.$refs['rooms-manager'].init();
        this.$refs['room-sets-manager'].init();
        this.$refs['venues-manager'].init();
        this.activated=true;
      }
    },
  }
}
</script>

<style scoped>

</style>
