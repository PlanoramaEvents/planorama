<template>
  <div>
    <b-tabs content-class="mt-3" @activate-tab="handleTabActivation" @input="input"><!-- v-if="person"-->
      <b-tab title="Rooms" :active="!tab" lazy>
        <h2>Rooms</h2>
        <RoomsManager model="room" ref="rooms-manager"></RoomsManager>
        <!--rooms-manager
          v-model="room"
          :model="roomModel"
        ></rooms-manager-->
      </b-tab>
      <b-tab title="Venues" :active="tab === 'venues'" lazy>
        <h2>Venues</h2>
        <VenuesManager model="venue" ref="venues-manager"></VenuesManager>
        <!--venues-manager :selected="venue"></venues-manager-->
      </b-tab>
      <b-tab title="Roomsets" :active="tab === 'roomsets'" lazy>
        <h2>Roomsets</h2>
        <RoomSetsManager model="room_set" ref="room-sets-manager"></RoomSetsManager>
        <!--roomsets-manager :selected="roomset"></roomsets-manager-->
      </b-tab>
    </b-tabs>
  </div>
</template>


<script>
import RoomsManager from './rooms_manager.vue';
import VenuesManager from './venues_manager.vue';
import RoomSetsManager from './room_sets_manager.vue';

import VueRouter from 'vue-router';
const { isNavigationFailure, NavigationFailureType } = VueRouter;

export default {
  name: "VenuesTabs",
  props: ['tab', 'id'],
  components: {RoomsManager, VenuesManager, RoomSetsManager},
  data() {
    return {
      activated: false
    }
  },
  methods: {
    input() {
      if(this.$refs['rooms-manager'])
        this.$refs['rooms-manager'].init();
      if(this.$refs['room-sets-manager'])
        this.$refs['room-sets-manager'].init();
      if(this.$refs['venues-manager'])
        this.$refs['venues-manager'].init();
    },
    handleTabActivation(newTab) {
      let path = '';
      switch(newTab) {
        case 0:
          path = '';
          break;
        case 1:
          path = 'venues';
          break;
        case 2:
          path = 'roomsets';
          break;
      }
      // change the router path to match the current tab
      // so that reloads work right
      this.$router.push(`/venues/${path}`).catch(error => {
        if(!isNavigationFailure(error, NavigationFailureType.duplicated)) {
          // ignore the duplicates, otherwise -
          throw error;
        }
      })
    }
  },
    // mounted() {
    //   // get id from URL if present
    //   let id = this.id ? this.id : this.currentUser.id
    //   this.fetch_model_by_id(personModel, id).then(
    //       (obj) => {
    //         this.person = obj
    //       }
    //   )
    // },
}
</script>

<style scoped>

</style>
