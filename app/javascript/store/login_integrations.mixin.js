import settingsMixin from "./settings.mixin";

export const transformIntegration = (integrationObj) => ({
  name: integrationObj.name,
  endpoint: `/auth/${integrationObj.name}`,
  registration: integrationObj?.config?.registration,
  buttonText: integrationObj?.config?.button_text,
  linkText: integrationObj?.config?.link_text,
});

export const loginIntegrationsMixin = {
  props: {
    redirect: {
      type: String,
      default: null
    }
  },
  mixins: [settingsMixin],
  computed: {
    enabledIntegrations() {
      return this.currentSettings.login_integrations?.map(transformIntegration) || []
    },
    registrationIntegration() {
      return this.enabledIntegrations.find(i => i.registration);
    },
    clydeIntegration() {
      return this.enabledIntegrations.find(i => i.name === "clyde");
    },
    csrfToken() {
      let token = $cookies.get('XSRF-TOKEN')
      return token
    },
  },
}
