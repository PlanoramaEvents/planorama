<template>
  <div>
    <b-tabs @input="input">
      <b-tab title="Rooms">
        <RoomsManager model="room" ref="rooms-manager"></RoomsManager>
      </b-tab>
      <b-tab title="Venues">
        <VenuesManager model="venue" ref="venues-manager"></VenuesManager>
      </b-tab>
      <b-tab title="Room Setups">
        <RoomsetsManager model="roomset" ref="roomsets-manager"></RoomsetsManager>
      </b-tab>
    </b-tabs>
  </div>
</template>

<script>
import RoomsManager from './rooms_manager.vue';
import VenuesManager from './venues_manager.vue';
import RoomsetsManager from './roomsets_manager.vue';

export default {
  name: "VenueManager",
  components: {RoomsManager, VenuesManager, RoomsetsManager},
  data() {
    return {
      activated: false
    }
  },
  methods: {
    input() {
      if(!this.activated) {
        this.$refs['rooms-manager'].init();
        this.$refs['roomsets-manager'].init();
        this.$refs['venues-manager'].init();
        this.activated=true;
      }
    },
  }
}
</script>

<style scoped>

</style>