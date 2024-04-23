<template>
  <div class="scrollable">
    <div class="login-screen container mb-3">
      <plan-logo></plan-logo>
      <router-view :redirect="redirect"></router-view>
    </div>
  </div>
</template>

<script>
import PlanLogo from "@/logo";
import { personSessionMixin } from '@mixins';

export default {
  name: "LoginScreen",
  props: ['redirect'],
  components: {
    PlanLogo,
  },
  mixins: [
    personSessionMixin
  ],
  watch: {
        // NOTE:
    // This causes a double redirect cause the router does the same thing
    // and throughs an error which sometime causes the survey etc not to render
    // AND the logic for this is handled in the router anyway
    // Hence the commenting out
    // loggedIn (newval, oldval) {
    //   if (newval) {
    //     if (this.hasPassword) {
    //       this.$router.replace(this.redirect)
    //     } else {
    //       this.$router.push(`/login/setup?redirect=${this.redirect}`)
    //     }
    //   }
    // },
    hasPassword(newVal, oldVal) {
      if (newVal && !oldVal) {
        this.$router.replace(this.redirect)
      }
    }
  }
};
</script>

<style lang="scss" scoped>
@media (max-width: 576px) {
  .login-screen {
    width: 100%;
  }
}
@media (min-width: 577px) {
  .login-screen {
    width: 500px;
    margin: 0 auto;
  }
}
</style>
