import Vue from 'vue/dist/vue.esm';
import VueRouter from 'vue-router';
import Vuex from 'vuex';

import { BootstrapVue } from 'bootstrap-vue';

import LoginScreen from '../login/login_screen.vue'
import ForgotPassword from '../login/forgot_password.vue'
import PlanLogin from '../login/login.vue';
import NewPassword from '../login/new_password.vue';

Vue.use(BootstrapVue);
Vue.use(VueRouter);
Vue.use(Vuex);
import {store as adminStore } from '../administration/admin.store';
import { store as agreementStore } from '../administration/agreement.store'

Vue.use(Vuex);
const store = adminStore.initialize(Vuex)
agreementStore.registerAsModuleFor(store);

const routes = [
    { path: '/forgot', component: ForgotPassword },
    { path: '/password-reset', component: NewPassword },
    { path: '/', component: PlanLogin },
]

const router = new VueRouter({
    routes
})

const app = new Vue({
    components: {
        LoginScreen,
    },
    router,
    store
});
document.addEventListener('DOMContentLoaded', () => {
    app.$mount('#login-app');
});

