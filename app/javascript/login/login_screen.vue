<template>
  <div class="login-screen container">
    <plan-logo></plan-logo>
    <router-view></router-view>
  </div>
</template>

<script>
import PlanLogo from "../logo.vue";

export default {
  name: "LoginScreen",
  components: {
    PlanLogo,
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
