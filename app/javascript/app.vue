<template>
  <div class="container-fluid">
    <sign-agreements ref="agreement-signer"></sign-agreements>
    <div class="row">
      <top-navbar></top-navbar>
      <side-navbar v-if="loggedIn"></side-navbar>
      <div :class="['col-12 pr-0', { 'col-sm-10': loggedIn, 'col-xl-10': loggedIn}]">
        <router-view></router-view>
      </div>
      <bottom-navbar></bottom-navbar>
    </div>
  </div>
</template>

<script>
import 'vue-cal/dist/drag-and-drop.js'

import TopNavbar from "./navbar/top-navbar.vue";
import SideNavbar from "./navbar/side-navbar.vue";
import BottomNavbar from "./navbar/bottom-navbar.vue";
import personSessionMixin from "./auth/person_session.mixin";
import SignAgreements from "./agreements/sign_agreements.vue";
import settingsMixin from "@/store/settings.mixin";
import { ValidationProvider, extend } from 'vee-validate';
//
// v-validate="{url: {require_protocol: true }}
import { required, email, numeric, digits, regex } from 'vee-validate/dist/rules';

import VueCal from 'vue-cal'
import 'vue-cal/dist/vuecal.css'

extend('email', email);
extend('numeric', numeric);
extend('digits', digits);
extend('regex', regex);

// Override the default message.
extend('required', {
  ...required,
  message: 'This field is required'
});

export default  {
  name: "PlanoramaApp",
  components: {
    VueCal,
    ValidationProvider,
    TopNavbar,
    SideNavbar,
    BottomNavbar,
    SignAgreements
  },
  mixins: [personSessionMixin, settingsMixin],
  methods: {
    check_signatures() {
      // TODO: @RALPH - this passes along the check signatures to the agreement signer ...
      this.$refs['agreement-signer'].check_signatures()
    }
  },
  mounted() {
    // fetch the current settings on mount !!!
    this.fetchSettings();
  }
}
</script>

<!-- this.$refs['agreement-checker'].savePerson() -->

<style lang="scss" scoped>

</style>
