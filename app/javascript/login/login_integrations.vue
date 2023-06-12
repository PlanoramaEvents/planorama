<template>
  <div class="d-flex align-items-center flex-column" v-if="enabledIntegrations.length">
    <form :action="integration.endpoint" method="post" v-for="integration in enabledIntegrations" :key="integration.endpoint">
      <input type="hidden" v-model="csrfToken" name="authenticity_token" />
      <b-button type="submit" variant="primary">{{ integration.buttonText }}</b-button> 
    </form>
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
  computed: {
    csrfToken() {
      let token = $cookies.get('XSRF-TOKEN')
      return token
    }
  }
}
</script>
