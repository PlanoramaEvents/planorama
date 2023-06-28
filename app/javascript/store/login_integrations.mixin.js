export const loginIntegrationsMixin = {
  props: {
    redirect: {
      type: String,
      default: null
    }
  },
  data: () => ({
    staticIntegrationsForTesting: [
      {endpoint: '/auth/clyde', name: 'Clyde', registration: true},
    ]
  }),
  computed: {
    enabledIntegrations() {
      // TODO actually fetch me from the backend
      return this.staticIntegrationsForTesting;
    },
    registrationIntegration() {
      return this.enabledIntegrations.find(i => i.registration);
    },
    csrfToken() {
      let token = $cookies.get('XSRF-TOKEN')
      return token
    }
  }
}
