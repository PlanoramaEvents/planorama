<template>
    <div class="container-fluid">
      <sign-agreements ref="agreement-signer"></sign-agreements>
      <div class="row">
        <top-navbar></top-navbar>
        <side-navbar v-if="loggedIn"></side-navbar>
          <div :class="['col-12 pr-0', { 'col-sm-10': loggedIn, 'col-xl-10': loggedIn}]">
            <b-overlay :show="wholePageSpinner">
            <router-view :key="magicalReload"></router-view>
            </b-overlay>
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
import { ValidationProvider } from 'vee-validate';

import VueCal from 'vue-cal'
import 'vue-cal/dist/vuecal.css'
import { mapState, mapActions } from 'vuex';
import { FETCH_WORKFLOWS } from '@/store/schedule_workflow';

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
  data() {
    return {
      showOverlay: false
    }
  },
  computed: {
    ...mapState(['magicalReload', 'wholePageSpinner'])
  },
  methods: {
    ...mapActions({
      fetchScheduleWorkflows: FETCH_WORKFLOWS,
    }),
    check_signatures() {
      // TODO: @RALPH - this passes along the check signatures to the agreement signer ...
      this.$refs['agreement-signer'].check_signatures()
    },
  },
  mounted() {
    // fetch the current settings on mount !!!
    this.fetchSettings();
    // fetch the schedule state too
    this.fetchScheduleWorkflows();
  }
}
</script>

<!-- this.$refs['agreement-checker'].savePerson() -->

<style lang="scss" scoped>

</style>
