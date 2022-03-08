<template>
  <div class="container-fluid">
    <sign-agreements ref="agreement-signer"></sign-agreements>
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
import SignAgreements from "./agreements/sign_agreements.vue"
import { ValidationProvider, extend } from 'vee-validate';
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
    SignAgreements
  },
  mixins: [personSessionMixin],
  methods: {
    check_signatures() {
      // TODO: @RALPH - this passes along the check signatures to the agreement signer ...
      this.$refs['agreement-signer'].check_signatures()
    }
  }
}
</script>

<!-- this.$refs['agreement-checker'].savePerson() -->

<style lang="scss" scoped>

</style>
