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
import personSessionMixin from "./auth/person_session.mixin";
import { ValidationProvider } from 'vee-validate';

import { extend } from 'vee-validate';
import { required, email, numeric } from 'vee-validate/dist/rules';

extend('email', email);
extend('numeric', numeric);

// Override the default message.
extend('required', {
  ...required,
  message: 'This field is required'
});

export default  {
  name: "PlanoramaApp",
  components: {
    ValidationProvider,
    TopNavbar,
    SideNavbar,
    BottomNavbar,
  },
  mixins: [personSessionMixin],
}
</script>

<style lang="scss" scoped>

</style>
