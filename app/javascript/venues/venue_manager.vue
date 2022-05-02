<template>
  <div>
    <b-tabs>
      <b-tab title="Rooms">
        <RoomsManager></RoomsManager>
      </b-tab>
      <b-tab title="Venues">
        Venues Manager Here
        <!--VenuesManager></VenuesManager-->
      </b-tab>
      <b-tab title="Room Setups">
        RoomSets Manager Here
        <!--RoomSetsManager></RoomSetsManager-->
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
  components: {RoomsManager, VenuesManager, RoomSetsManager}
}
</script>

<style scoped>

</style>