import Vue from 'vue/dist/vue.esm';
import VueRouter from 'vue-router';

import { BootstrapVue } from 'bootstrap-vue';

import LoginScreen from '../login/login_screen.vue'
import ForgotPassword from '../login/forgot_password.vue'
import PlanLogin from '../login/login.vue';

Vue.use(BootstrapVue);
Vue.use(VueRouter);

const routes = [
    {path: '/forgot', component: ForgotPassword},
    {path: '/', component: PlanLogin},
]

const router = new VueRouter({
    routes
})

const app = new Vue({
    components: {
        LoginScreen,
    },
    router
});
document.addEventListener('DOMContentLoaded', () => {
    app.$mount('#login-app');
});

