// /* eslint no-console: 0 */
// import Vue from 'vue'
// import Vuex from 'vuex';
// import { NavbarPlugin, BootstrapVue, BootstrapVueIcons } from 'bootstrap-vue'
// import { CustomIconsPlugin } from '../icons';
//
// import HelpLink from '../administration/help_link.vue';
// import TermsOfUseLink from '../administration/terms_of_use_link.vue';
// import PrivacyPolicyLink from '../administration/privacy_policy_link.vue';
// import IeaModal from '../login/iea-modal.vue';
//
// import {store as adminStore } from '../administration/admin.store';
// import {store as configurationStore } from '../administration/configurations.store';
// import { store as agreementStore } from '../administration/agreement.store'
// import authMixin from '../auth.mixin';
//
// Vue.use(Vuex);
// const store = adminStore.initialize(Vuex)
// configurationStore.registerAsModuleFor(store);
// agreementStore.registerAsModuleFor(store);
//
// Vue.use(NavbarPlugin)
// Vue.use(BootstrapVue)
// Vue.use(BootstrapVueIcons)
// Vue.use(CustomIconsPlugin)
//
// document.addEventListener('DOMContentLoaded', () => {
//   if (document.getElementById('top-navbar')) {
//     const app = new Vue({
//       el: '#top-navbar',
//       data: () => {
//         return {
//           isActive: true,
//           currentLocation: location.pathname
//         }
//       },
//       components: {
//         HelpLink,
//       },
//       store
//     })
//   }
//   if (document.getElementById('side-navbar')) {
//     const app2 = new Vue({
//       el: '#side-navbar',
//       components: {
//         IeaModal
//       },
//       data: () => {
//         return {
//           isActive: true,
//           currentLocation: location.pathname
//         }
//       },
//       store,
//       mixins: [authMixin],
//       methods: {
//         onCancelIea() {
//           this.signOut();
//         }
//       }
//     });
//   }
//   const app3 = new Vue({
//     el: '#bottom-navbar',
//     components: {
//       PrivacyPolicyLink,
//       TermsOfUseLink
//     }
//   })
// })
