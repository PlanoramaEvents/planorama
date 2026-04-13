<template>
  <div class="scrollable">
    <div class="mt-3">
      <b-tabs content-class="mt-3" @activate-tab="handleTabActivation">
        <b-tab title="Rooms" :active="tab === 'rooms'" lazy>
          <RoomsManager model="room" ref="rooms-manager"></RoomsManager>
        </b-tab>
        <b-tab title="Venues" :active="tab === 'venues'" lazy>
          <VenuesManager model="venue" ref="venues-manager"></VenuesManager>
        </b-tab>
      </b-tabs>
    </div>
  </div>
</template>

<script>
import RoomsManager from '@/venues/rooms_manager.vue';
import VenuesManager from '@/venues/venues_manager.vue';

export default {
  name: "VenueAndRoomManager",
  components: {RoomsManager, VenuesManager},
  props: [
    'tab'
  ],
  methods: {
    handleTabActivation(newTab, oldTab, bvEvent) {
      let path = '';
      switch(newTab) {
        case 0:
          path = `rooms`;
          break;
        case 1:
          path = `venues`;
          break;
      }
      this.$router.push(`/venues/${path}`).catch(error => {
        if(!isNavigationFailure(error, NavigationFailureType.duplicated)) {
          // ignore the duplicates, otherwise -
          throw error;
        }
      })
    }
  }
}
</script>

<style scoped>

</style>
