export const loginIntegrationsMixin = {
  data: () => ({
    staticIntegrationsForTesting: [{endpoint: '/auth/clyde', buttonText: 'Log in with Clyde'}]
  }),
  computed: {
    enabledIntegrations() {
      // TODO actually fetch me from the backend
      return this.staticIntegrationsForTesting;
    }
  }
}
