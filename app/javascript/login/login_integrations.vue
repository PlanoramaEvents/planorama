<template>
  <div class="d-flex align-items-center flex-column pt-3" v-if="enabledIntegrations.length">
    <login-small-print></login-small-print>
    <!-- The oauth params to pass through have to be GET params rather than hidden inputs -->
    <form :action="integration.endpoint + '?redirect=' + redirect" method="post" v-for="integration in enabledIntegrations" :key="integration.endpoint" class="w-100">
      <input type="hidden" v-model="csrfToken" name="authenticity_token" />
      <b-button type="submit" variant="primary" class="w-100 mb-2">{{ integration.buttonText || "Log in with " + integration.name }}</b-button>
    </form>
    <div class="d-flex flex-column my-3" v-if="enabledIntegrations.length">
      <span>You can also <router-link :to="'/login/?redirect=' + redirect">Log In</router-link> with a username and password.</span>
    </div>
  </div>
</template>

<script>
import { loginIntegrationsMixin } from '@/store/login_integrations.mixin';
import LoginSmallPrint from './login_small_print.vue'

export default {
  name: "LoginIntegrations",
  mixins: [loginIntegrationsMixin],
  components: {
    LoginSmallPrint
  }
}
</script>
