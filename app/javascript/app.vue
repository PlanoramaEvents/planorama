<template>
  <div class="container-fluid">
    <div class="row">
      <top-navbar></top-navbar>
      <side-navbar v-if="loggedIn"></side-navbar>
      <div :class="['col-12 pr-0', { 'col-sm-9': loggedIn, 'col-xl-10': loggedIn}]">
        <router-view></router-view>
      </div>
      <bottom-navbar></bottom-navbar>
    </div>
  </div>
</template>

<script>

import TopNavbar from "./navbar/top-navbar.vue";
import SideNavbar from "./navbar/side-navbar.vue";
import BottomNavbar from "./navbar/bottom-navbar.vue";
import personsessionMixin from "./auth/person_session.mixin";

export default  {
  name: "PlanoramaApp",
  components: {
    TopNavbar,
    SideNavbar,
    BottomNavbar,
  },
  mixins: [personsessionMixin],
}
</script>

<style lang="scss" scoped>

</style>
