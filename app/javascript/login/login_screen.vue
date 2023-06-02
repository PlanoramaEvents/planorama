<template>
  <div class="scrollable">
    <div class="login-screen container mb-3">
      <!-- TODO: temp button to login to CLYDE, replace with proper UI -->
      <form action="/auth/clyde" method="post" id="clyde-form">
        <input type="hidden" v-model="csrfToken" name="authenticity_token" />
        <button type="submit" form="clyde-form" value="Submit">CLYDE</button> 
      </form>
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
  computed: {
    csrfToken() {
      let token = $cookies.get('XSRF-TOKEN')
      return token
    }
  },
  watch: {
    loggedIn (newval, oldval) {
      if (newval) {
        if (this.hasPassword) {
          this.$router.replace(this.redirect)
        } else {
          this.$router.push(`/login/setup?redirect=${this.redirect}`)
        }
      }
    },
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
