<template>
  <div class="login-screen container">
    <plan-logo></plan-logo>
    <router-view></router-view>
  </div>
</template>

<script>
import PlanLogo from "../logo.vue";
import { sessionMixin } from '@mixins';

export default {
  name: "LoginScreen",
  props: ['redirect'],
  components: {
    PlanLogo,
  },
  mixins: [
    sessionMixin
  ],
  watch: {
    loggedIn (newval, oldval) {
      if (newval) {
        this.$router.replace(this.redirect)
      }
    }
  },
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
