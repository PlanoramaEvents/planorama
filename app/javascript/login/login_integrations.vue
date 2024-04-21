<template>
  <div class="d-flex flex-column pt-3" v-if="enabledIntegrations.length">
    <!-- The oauth params to pass through have to be GET params rather than hidden inputs -->
    <form :action="integration.endpoint + '?redirect=' + redirect" method="post" v-for="integration in enabledIntegrationsNoClyde" :key="integration.endpoint" class="w-100">
      <input type="hidden" v-model="csrfToken" name="authenticity_token" />
      <b-button type="submit" variant="primary" class="w-100 mb-2">{{ integration.buttonText || "Log in with " + integration.name }}</b-button>
    </form>
    <span v-if="clydeIntegration && !noClydeLogin">You can also <router-link :to="'/login/clyde?redirect=' + redirect">Log In</router-link> with {{ clydeIntegration.linkText || 'Clyde' }}.</span>
  </div>
</template>

<script>
import { loginIntegrationsMixin } from '@/store/login_integrations.mixin';

export default {
  name: "LoginIntegrations",
  mixins: [loginIntegrationsMixin],
  data: () => ({
    // the way clyde does logins is stupid
    noClydeLogin: true
  }),
  params: {
    redirect: {
      type: String,
      default: null
    }
  },
  computed: {
    enabledIntegrationsNoClyde() {
      this.enabledIntegrations.filter(i => i.name !== 'clyde')
    }
  }
}
</script>
