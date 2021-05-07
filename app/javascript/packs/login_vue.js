import Vue from 'vue/dist/vue.esm';

import { BootstrapVue } from 'bootstrap-vue';

import 'bootstrap/dist/css/bootstrap.css';
import 'bootstrap-vue/dist/bootstrap-vue.css';

import PlanLogo from '../logo.vue';
import PlanLogin from '../login.vue';
import PlanLoginFooter from '../login_footer.vue';

Vue.use(BootstrapVue);

const app = new Vue({
    components: {
        PlanLogo,
        PlanLogin,
        PlanLoginFooter,
    },

});
document.addEventListener('DOMContentLoaded', () => {
    app.$mount('#login-app');
});
