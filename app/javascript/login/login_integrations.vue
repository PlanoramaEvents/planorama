<template>
  <div class="d-flex align-items-center flex-column" v-if="enabledIntegrations.length">
    <p class="lines-around d-flex align-items-center w-100">OR</p>
    <form :action="integration.endpoint" method="post" v-for="integration in enabledIntegrations" :key="integration.endpoint">
      <input type="hidden" v-model="csrfToken" name="authenticity_token" />
      <b-button type="submit" variant="primary">{{ integration.buttonText }}</b-button> 
    </form>
  </div>
</template>

<script>
import { loginIntegrationsMixin } from '@/store/login_integrations.mixin';

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

<style lang="scss" scoped>
.lines-around::after, .lines-around::before {
  content: "";
  flex: 1 1 0%;
  border-bottom: 1px solid black;
}

.lines-around::before {
  margin-right: 0.5rem;
}

.lines-around::after {
  margin-left: 0.5rem;
}
</style>
