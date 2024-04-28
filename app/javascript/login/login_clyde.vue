<template>
  <div class="d-flex flex-column pt-3" v-if="clydeIntegration">
    <login-small-print></login-small-print>
    <!-- The oauth params to pass through have to be GET params rather than hidden inputs -->
    <!-- TODO: this is not correct text, it is misleading as to what is actually happening
    <b-alert show variant="warning">Logging in with Clyde will link your convention membership with your Planorama account, even if you have previously unlinked it.</b-alert>
    -->
    <form :action="clydeIntegration.endpoint + '?redirect=' + redirect" method="post" class="w-100">
      <input type="hidden" v-model="csrfToken" name="authenticity_token" />
      <b-button type="submit" variant="primary" class="w-100 my-2">{{ clydeIntegration.buttonText || "Log in with Clyde" }}</b-button>
    </form>
    <span class="mt-2">You can also <router-link :to="'/login?redirect=' + redirect">Log In</router-link> with a username and password.</span>
  </div>
</template>

<script>
import { loginIntegrationsMixin } from '@/store/login_integrations.mixin'
import LoginSmallPrint from './login_small_print.vue'
export default {
  export: "LoginClyde",
  props: ["redirect"],
  mixins: [
    loginIntegrationsMixin
  ],
  components: {
    LoginSmallPrint
  }
}
</script>

<style>

</style>
