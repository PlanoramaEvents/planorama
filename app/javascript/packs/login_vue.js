import Vue from 'vue/dist/vue.esm';

import { BootstrapVue } from 'bootstrap-vue';

import PlanLogo from '../logo.vue';
import PlanLogin from '../login/login.vue';
import PlanLoginFooter from '../login/login_footer.vue';

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

