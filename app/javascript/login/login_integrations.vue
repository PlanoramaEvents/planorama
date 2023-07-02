<template>
  <div class="d-flex align-items-center flex-column pt-3" v-if="enabledIntegrations.length">
    <!-- The oauth params to pass through have to be GET params rather than hidden inputs -->
    <form :action="integration.endpoint + '?redirect=' + redirect" method="post" v-for="integration in enabledIntegrations" :key="integration.endpoint" class="w-100">
      <input type="hidden" v-model="csrfToken" name="authenticity_token" />
      <b-button type="submit" variant="primary" class="w-100 mb-2">{{ integration.buttonText || "Log in with " + integration.name }}</b-button>
    </form>
    <p class="lines-around d-flex align-items-center w-100 pt-3">OR</p>
  </div>
</template>

<script>
import { loginIntegrationsMixin } from '@/store/login_integrations.mixin';

/*
  TODO: thera are two cases where we provide the login

  1. Login screen

  2. Associate account
  - in this case the login process associates the OAuth identitu with the current process
  - the me endpoint will come back with list of associated identities
  - we should only show the associate/login (on profile or wherever page) for person that does
    not have that identity associated
 */

export default {
  name: "LoginIntegrations",
  mixins: [loginIntegrationsMixin],
}
</script>
