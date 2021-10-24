<template>
  <div class="container-fluid">
    <div class="row">
      <top-navbar></top-navbar>
      <side-navbar v-if="loggedIn"></side-navbar>
      <div :class="['col-12', { 'col-sm-9': loggedIn, 'col-xl-10': loggedIn}]">
        <router-view></router-view>
      </div>
    </div>
    <bottom-navbar></bottom-navbar>
  </div>
</template>

<script>
import TopNavbar from "./navbar/top-navbar.vue";
import SideNavbar from "./navbar/side-navbar.vue";
import BottomNavbar from "./navbar/bottom-navbar.vue";
import sessionMixin from "./session/session.mixin";
import { store } from './store/model.store';

export default  {
  name: "PlanoramaApp",
  components: {
    TopNavbar,
    SideNavbar,
    BottomNavbar,
  },
  store,
  mixins: [sessionMixin],
  mounted() {
  }
}
</script>

<style>

</style>
