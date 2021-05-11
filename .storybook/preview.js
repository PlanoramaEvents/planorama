
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

export const parameters = {
  actions: { argTypesRegex: "^on[A-Z].*" },
  controls: {
    matchers: {
      color: /(background|color)$/i,
      date: /Date$/,
    },
  },
}

import Vue from 'vue/dist/vue.esm';
import { BootstrapVue } from 'bootstrap-vue';

Vue.use(BootstrapVue)
